import { useState } from 'react'
import './App.css'
import CustomForm from './components/CustomForm'

function App() {
  const [tasks,setTasks] = useState([])
     
  const addTask = (task) => {
     setTasks(prevState => [...prevState, task])
  }
    
  return (
    <div className="container">
      <header>
        <h1> My tasks</h1>
      </header>
      <CustomForm addTask={addTask}/>
    </div>
  )
}

export default App
