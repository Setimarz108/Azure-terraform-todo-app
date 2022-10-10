import { useState } from "react";
import styles from "./ThemeSwitcher.module.css";
import {
  XMarkIcon,
  SunIcon,
  MoonIcon,
  SwatchIcon,
} from "@heroicons/react/24/outline";

import { useEffect } from "react";
import useLocalStorage from "../Hooks/useLocalStorage";

function ThemeSwitcher() {
  const [isColorPicking, setIsColorPicking] = useState(false);

  const defaultDark = window.matchMedia('(prefers-color-scheme: dark)').matches
  const [theme, setTheme] = useLocalStorage("todo.theme", defaultDark ? "dark" : "light");
  const [hue, setHue] = useLocalStorage("todo.color", "240");

  useEffect(() => {
    document.documentElement.setAttribute('color-scheme', theme)
  },[theme])

  useEffect(() => {
    document.documentElement.style.setProperty('--_hue', hue)
  },[hue])

  return (
    <aside 
    className={styles.wrapper}
    style={{
      backgroundColor: isColorPicking 
      ? 'hsl(var(--muted) / .6)'
      : 'transparent'
    }}
    >
      {isColorPicking ? (
        <>
          <button
            className={`btn ${styles.close}`}
            aria-label="Close color picking mode"
            onClick={() => setIsColorPicking(false)}
          >
            <XMarkIcon />
          </button>
          <input 
          className={styles.picker} 
          type="range"
          min="0"
          max="360"
          aria-label="Change color theme slider"
          value={hue}
          onInput={(e) => setHue(e.target.value)}
          />
        </>
      ) : (
        <div className={styles.btns}>
          <button
            className="btn"
            aria-label={`Change theme to ${
              theme === "light" ? "dark" : "light"
            } mode`}
            role="switch"
            onClick={() => setTheme(theme === "light" ? "dark" : "light")}
          >
            {theme === "dark" ? <SunIcon /> : <MoonIcon />}
          </button>
          <button
            className="btn"
            aria-label="Enable color picking mode"
            onClick={() => setIsColorPicking(true)}
          >
            <SwatchIcon />
          </button>
        </div>
      )}
    </aside>
  );
}

export default ThemeSwitcher;
