import { PlusIcon } from '@heroicons/react/24/solid'

export default function CustomForm() {
  const handleFormSubmit = (e) => {
    e.preventDefault();
  };
  return (
  
   <form className="todo" onSubmit={handleFormSubmit}>
    <div className="wrapper">
        <input 
        type="text"
        id="task"
        className="input"
        // onInput={ (e) => setTask(e.target.value)}
        required
        autoFocus
        maxLength={60}  
        placeholder="What´s on you mind?"      
        />
        <label
        htmlFor="task"
        className="label"
        >What´s on your mind?</label>
    </div>
    <button
       className="btn" 
       aria-label="Add Task"
       type="submit" 
        >
        <PlusIcon/>
       </button>
  </form>
  
  )
}
