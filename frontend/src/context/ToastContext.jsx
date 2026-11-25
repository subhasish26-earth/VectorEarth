import React, { createContext, useContext, useState, useCallback } from 'react';
import { CheckCircle2, AlertCircle, Info, X } from 'lucide-react';

const ToastContext = createContext(null);

export function ToastProvider({ children }) {
  const [toasts, setToasts] = useState([]);

  const addToast = useCallback((message, type = 'info', duration = 3500) => {
    const id = Date.now() + Math.random().toString(36).substring(2, 9);
    setToasts((prev) => [...prev, { id, message, type }]);

    if (duration > 0) {
      setTimeout(() => {
        setToasts((prev) => prev.filter((t) => t.id !== id));
      }, duration);
    }
  }, []);

  const removeToast = useCallback((id) => {
    setToasts((prev) => prev.filter((t) => t.id !== id));
  }, []);

  const toast = {
    success: (msg, dur) => addToast(msg, 'success', dur),
    error: (msg, dur) => addToast(msg, 'error', dur),
    info: (msg, dur) => addToast(msg, 'info', dur),
    warning: (msg, dur) => addToast(msg, 'warning', dur),
  };

  return (
    <ToastContext.Provider value={toast}>
      {children}
      {/* Toast Notification Container */}
      <div 
        className="fixed bottom-5 right-5 z-50 flex flex-col gap-2.5 max-w-sm w-full pointer-events-none"
        aria-live="polite"
        aria-atomic="true"
      >
        {toasts.map((t) => (
          <div
            key={t.id}
            className={`pointer-events-auto flex items-start gap-3 p-3.5 rounded-xl shadow-lg border text-xs font-medium transition-all transform translate-y-0 opacity-100 ${
              t.type === 'success'
                ? 'bg-emerald-950 text-emerald-100 border-emerald-800 shadow-emerald-950/20'
                : t.type === 'error'
                ? 'bg-rose-950 text-rose-100 border-rose-800 shadow-rose-950/20'
                : t.type === 'warning'
                ? 'bg-amber-950 text-amber-100 border-amber-800 shadow-amber-950/20'
                : 'bg-slate-900 text-slate-100 border-slate-700 shadow-slate-950/20'
            }`}
            role="status"
          >
            <div className="shrink-0 mt-0.5">
              {t.type === 'success' && <CheckCircle2 className="w-4 h-4 text-emerald-400" />}
              {t.type === 'error' && <AlertCircle className="w-4 h-4 text-rose-400" />}
              {t.type === 'warning' && <AlertCircle className="w-4 h-4 text-amber-400" />}
              {t.type === 'info' && <Info className="w-4 h-4 text-sky-400" />}
            </div>
            <div className="flex-1 leading-relaxed break-words">{t.message}</div>
            <button
              onClick={() => removeToast(t.id)}
              className="shrink-0 text-white/50 hover:text-white p-0.5 rounded transition"
              aria-label="Close notification"
            >
              <X className="w-3.5 h-3.5" />
            </button>
          </div>
        ))}
      </div>
    </ToastContext.Provider>
  );
}

export function useToast() {
  const context = useContext(ToastContext);
  if (!context) {
    throw new Error('useToast must be used within a ToastProvider');
  }
  return context;
}
