import React, { useState, useEffect } from 'react';

function TaskList() {
    const [tasks, setTasks] = useState([]);

    useEffect(() => {
        fetchTasks();
    }, []);

    const fetchTasks = async () => {
        const response = await fetch('/api/task');
        const data = await response.json();
        setTasks(data);
    };

    return (
        <div>
            <h2>Task List</h2>
            <ul>
                {tasks.map(task => (
                    <li key={task.id}>
                        <strong>{task.name}</strong>: {task.description} - <em>{task.priority}</em>
                    </li>
                ))}
            </ul>
        </div>
    );
}

export default TaskList;
