<?php

namespace App\Http\Controllers;

use App\Models\Task;
use App\Models\Category;
use Illuminate\Http\Request;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

class TaskController extends Controller
{
    public function dashboard()
    {
        $userId = Auth::id();

        $stats = Task::where('user_id', $userId)
            ->selectRaw(//done = 1
                " COUNT(*) as total_tasks,
             SUM(status = 'Done') as completed_tasks,
              SUM(status = 'To Do') as pending_tasks,
               SUM(status = 'In Progress') as in_progress_tasks "
            )
            ->first();
        $completionPercentage = $stats->total_tasks > 0
            ? round(($stats->completed_tasks / $stats->total_tasks) * 100, 2)
            : 0;
        return response()->json([
            'total_tasks' => (int) $stats->total_tasks,
            'completed_tasks' => (int) $stats->completed_tasks,
            'pending_tasks' => (int) $stats->pending_tasks,
            'in_progress_tasks' => (int) $stats->in_progress_tasks,
            'completion_percentage' => $completionPercentage,
        ], 200);
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'category' => 'required|string',
            'priority' => 'required|in:Low,Medium,High',
            'status' => 'nullable|in:To Do,In Progress,Done',
            'due_date' => 'required|date',
            'reminder' => 'nullable|date',
            'notes' => 'nullable|string',
        ]);

        Category::firstOrCreate([
            'user_id' => Auth::id(),
            'name' => $request->category
        ]);

        $task = Task::create([
            'user_id' => Auth::id(), // لازم يسجل
            'title' => $request->title,
            'description' => $request->description,
            'category' => $request->category,
            'priority' => $request->priority,
            'status' => $request->status ?? 'To Do',
            'due_date' => $request->due_date,
            'reminder' => $request->reminder,
            'notes' => $request->notes,
        ]);

        return response()->json([
            'message' => 'Task created successfully',
            'task' => $task
        ], 201);
    }

    public function index(Request $request)
    {

        // new api
        $query = $request->get('deleted') == '1'
            ? Task::onlyTrashed()->where('user_id', Auth::id())
            : Task::where('user_id', Auth::id());

        if ($request->has('status') && $request->status != '') {// بعت ولا لا 
            $query->where('status', $request->status);  //لو موجود 
        }

        if ($request->has('priority') && $request->priority != '') {
            $query->where('priority', $request->priority);
        }

        if ($request->has('category') && $request->category != '') {
            $query->where('category', $request->category);
        }

        if ($request->has('search') && $request->search != '') {
            $search = $request->search;
            $query->where(function($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")  //title
                  ->orWhere('description', 'like', "%{$search}%")   //description
                  ->orWhere('notes', 'like', "%{$search}%")     //notes
                  ->orWhere('category', 'like', "%{$search}%");     //category
            });
        }

        $tasks = $query->get();

        return response()->json($tasks, 200);
    }

    public function show($id) // 1
    {
        $task = Task::where('user_id', Auth::id())->find($id);

        if (!$task) {
            return response()->json([
                'message' => 'Task not found'
            ], 404);
        }

        return response()->json($task, 200);
    }

    public function update(Request $request, $id)
    {
        $task = Task::where('user_id', Auth::id())->find($id);

        if (!$task) { // لو التاسك موجوده هنا الاول ولا لا 
            return response()->json([
                'message' => 'Task not found'
            ], 404);
        }

        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'category' => 'required|string',
            'priority' => 'required|in:Low,Medium,High',
            'status' => 'required|in:To Do,In Progress,Done',
            'due_date' => 'nullable|date',
            'reminder' => 'nullable|date',
            'notes' => 'nullable|string',
        ]);

        Category::firstOrCreate([
            'user_id' => Auth::id(),
            'name' => $request->category
        ]);

        $task->update([
            'title' => $request->title,
            'description' => $request->description,
            'category' => $request->category,
            'priority' => $request->priority,
            'status' => $request->status,
            'due_date' => $request->due_date,
            'reminder' => $request->reminder,
            'notes' => $request->notes,
        ]);

        return response()->json([
            'message' => 'Task updated successfully',
            'task' => $task
        ], 200);
    }

    public function destroy($id)
    {
        $task = Task::where('user_id', Auth::id())->find($id);

        if (!$task) {
            return response()->json([
                'message' => 'Task not found'
            ], 404);
        }

        $task->delete();

        return response()->json([
            'message' => 'Task deleted successfully'
        ], 200);
    }

    public function restore($id)
    {
        $task = Task::withTrashed()->where('user_id', Auth::id())->find($id);

        if (!$task) {
            return response()->json([
                'message' => 'Task not found'
            ], 404);
        }

        $task->restore();

        return response()->json([
            'message' => 'Task restored successfully',
            'task' => $task
        ], 200);
    }

    public function today()
    {
        $today = Carbon::today()->toDateString();

        $tasks = Task::where('user_id', Auth::id())
                     ->whereDate('due_date', $today)
                     ->get();

        return response()->json($tasks, 200);
    }
}