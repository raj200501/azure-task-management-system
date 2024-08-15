import React from 'react';
import TaskList from './components/TaskList';
import './index.css';

function App() {
    return (
        <div className="App">
            <header className="App-header">
                <h1>Azure Task Management System</h1>
            </header>
            <TaskList />
        </div>
    );
}

export default App;
