import styles from './TaskItem.module.css'
import {CheckIcon} from '@heroicons/react/24/outline'

function TaskItem({task}) {
  return (
    <li className={styles.task}>
        <div className={styles["task-group"]}>
           <input
            type="checkbox"
            className={styles.checkbox}
            checked={task.checked}
            name={task.name}
            id={task.id}
            // onChange={}
            />
            <label 
              htmlFor={task.id}
              className={styles.label}
              >
                {task.name}
                <p className={styles.checkmark}>
                    <CheckIcon strokeWidth={2} width={24}
                    height={24}/>
                </p>
            </label>
        </div>
    </li>
  )
}

export default TaskItem