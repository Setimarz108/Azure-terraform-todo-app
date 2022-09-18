import uuid from "react-uuid";
import TaskItem from "./TaskItem";
import styles from "./TaskList.module.css";

export default function TaskList({ tasks }) {
  return (
    <ul className={styles.tasks}>
      {tasks.sort((a, b) => b.id - a.id ).map((task) => (
        <TaskItem key={uuid()} task={task} />
      ))}
    </ul>
  );
}
