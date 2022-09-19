import { CheckIcon } from "@heroicons/react/24/solid";
import { useState,useEffect } from "react";


export default function EditForm({ editedTask, updateTask, closeEditMode }) {
  const [updatedTaskName, setUpdatedTaskName] = useState(editedTask.name);

  const handleFormSubmit = (e) => {
    e.preventDefault();
    updateTask({...editedTask, name:updatedTaskName})
  };

  useEffect(() => {
      const closeModal = (e) => {
        e.key === "Escape" && closeEditMode()
      }  
      window.addEventListener('keydown', closeModal) 

      return() =>{
        window.removeEventListener("keydown",closeModal)
      }

  }, [closeEditMode])

  return (
    <div 
    role="dialog"
     aria-labelledby="editTask" 
     onClick={(e) => {e.target === e.currentTarget && closeEditMode()}}

     >
      <form className="todo" onSubmit={handleFormSubmit}>
        <div className="wrapper">
          <input
            type="text"
            id="ediTtask"
            className="input"
            value={updatedTaskName}
            onInput={(e) => setUpdatedTaskName(e.target.value)}
            required
            autoFocus
            maxLength={60}
            placeholder="Update Task"
          />
          <label htmlFor="editTask" className="label">
            What´s on your mind?
          </label>
        </div>
        <button className="btn" aria-label="Update Task" type="submit">
          <CheckIcon stroke={22} height={24}
          width={24}/>
        </button>
      </form>
    </div>
  );
}
