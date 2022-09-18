import { PlusIcon } from "@heroicons/react/24/solid";
import { useState } from "react";

export default function CustomForm({addTask}) {
  const [task, setTask] = useState("");

  const handleFormSubmit = (e) => {
    e.preventDefault();
    addTask({
        name:task,
        checked: false,
        id: Date.now
    })
    setTask("");
  };

  return (
    <form className="todo" onSubmit={handleFormSubmit}>
      <div className="wrapper">
        <input
          type="text"
          id="task"
          className="input"
          value={task}
          onInput={(e) => setTask(e.target.value)}
          required
          autoFocus
          maxLength={60}
          placeholder="What´s on you mind?"
        />
        <label htmlFor="task" className="label">
          What´s on your mind?
        </label>
      </div>
      <button className="btn" aria-label="Add Task" type="submit">
        <PlusIcon />
      </button>
    </form>
  );
}
