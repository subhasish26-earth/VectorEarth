import { useState, useEffect } from 'react';
import { X, HelpCircle, Send, CheckCircle2, ShieldAlert, AlertTriangle } from 'lucide-react';
import { api } from '../services/api';

export default function DisputeHelpdeskModal({ isOpen, onClose, bookingId, onDisputeCreated }) {
  const [issueType, setIssueType] = useState('Quality Concern');
  const [description, setDescription] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(false);
  const [ticketCode, setTicketCode] = useState('');

  useEffect(() => {
    if (!isOpen) return;
    const handleKeyDown = (e) => {
      if (e.key === 'Escape') handleClose();
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [isOpen]);

  if (!isOpen) return null;

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!description.trim()) return;

    setLoading(true);
    setError('');
    try {
      const res = await api.createDispute({
        bookingId,
        issueType,
        description,
      });
      setTicketCode(res.ticket?.ticket_code || 'DISP-2026-NEW');
      setSuccess(true);
      if (onDisputeCreated) onDisputeCreated();
    } catch (err) {
      setError(err.message || 'Failed to submit grievance');
    } finally {
      setLoading(false);
    }
  };

  const handleClose = () => {
    setSuccess(false);
    setDescription('');
    setError('');
    onClose();
  };

  return (
    <div 
      onClick={(e) => { if (e.target === e.currentTarget) handleClose(); }}
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs overscroll-contain animate-in fade-in duration-150"
      role="dialog"
      aria-modal="true"
      aria-labelledby="dispute-modal-title"
    >
      <div className="bg-white rounded-2xl max-w-lg w-full p-6 shadow-2xl border border-gray-100 overscroll-contain animate-in zoom-in-95 duration-150">
        {/* Header */}
        <div className="flex items-center justify-between pb-4 border-b border-gray-100">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-amber-50 text-amber-700 flex items-center justify-center font-bold">
              <HelpCircle className="w-5 h-5" />
            </div>
            <div>
              <h2 id="dispute-modal-title" className="text-base font-bold text-blue-950">Human Dispute & Grievance Desk</h2>
              <p className="text-xs text-gray-500">Direct federation supervisor arbitration (No bot dead-ends)</p>
            </div>
          </div>
          <button
            onClick={handleClose}
            className="p-1.5 rounded-lg text-gray-400 hover:text-gray-700 hover:bg-gray-100 transition-colors"
            aria-label="Close dispute modal"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {error && (
          <div className="mt-4 p-3 bg-red-50 border border-red-200 text-red-700 text-xs rounded-xl flex items-center gap-2" role="alert">
            <AlertTriangle className="w-4 h-4 shrink-0 text-red-600" />
            <span>{error}</span>
          </div>
        )}

        {success ? (
          <div className="py-8 text-center space-y-3">
            <div className="w-12 h-12 rounded-full bg-emerald-100 text-emerald-700 flex items-center justify-center mx-auto">
              <CheckCircle2 className="w-6 h-6" />
            </div>
            <h3 className="text-base font-bold text-gray-900">Grievance Ticket Registered</h3>
            <p className="text-xs text-gray-600 max-w-xs mx-auto">
              Ticket Code: <strong className="text-blue-950 font-mono text-sm">{ticketCode}</strong>
            </p>
            <p className="text-[11px] text-gray-500 max-w-sm mx-auto leading-relaxed">
              Your grievance has been lodged on the Cooperative Federation Ledger. An Area Supervisor will contact both parties within 4 operational hours.
            </p>
            <div className="pt-2">
              <button
                type="button"
                onClick={handleClose}
                className="btn btn-primary btn-sm px-6 text-xs font-bold"
              >
                Close Desk
              </button>
            </div>
          </div>
        ) : (
          <form onSubmit={handleSubmit} className="mt-4 space-y-4">
            <div>
              <label className="block text-xs font-bold text-gray-700 mb-1">
                Grievance Category
              </label>
              <select
                value={issueType}
                onChange={(e) => setIssueType(e.target.value)}
                className="w-full text-xs p-2.5 bg-gray-50 border border-gray-200 rounded-xl focus:bg-white focus:border-blue-900 focus:outline-hidden"
              >
                <option value="Quality Concern">Workmanship / Quality Concern</option>
                <option value="Billing Discrepancy">Billing or Rate Card Discrepancy</option>
                <option value="Delay or Non-Attendance">Technician Delayed / Non-Attendance</option>
                <option value="Misbehavior or Safety">Behavioral or Safety Violation</option>
                <option value="Parts Warranty Claim">Replacement Part Failure (30-Day Warranty)</option>
              </select>
            </div>

            <div>
              <label className="block text-xs font-bold text-gray-700 mb-1">
                Description of the Incident
              </label>
              <textarea
                required
                rows={4}
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                placeholder="Explain the issue clearly. Mention if parts were installed or if an unapproved charge was requested..."
                className="w-full text-xs p-3 bg-gray-50 border border-gray-200 rounded-xl focus:bg-white focus:border-blue-900 focus:outline-hidden"
              />
            </div>

            <div className="p-3 bg-blue-50/60 rounded-xl border border-blue-100 flex items-start gap-2.5 text-[11px] text-blue-900">
              <ShieldAlert className="w-4 h-4 shrink-0 text-blue-700 mt-0.5" />
              <span>
                <strong>Cooperative Protection:</strong> Payment remains in escrow until your grievance is resolved by the district federation arbitration cell.
              </span>
            </div>

            <div className="flex items-center justify-end gap-2.5 pt-2">
              <button
                type="button"
                onClick={handleClose}
                className="btn btn-secondary btn-sm text-xs font-semibold"
              >
                Cancel
              </button>
              <button
                type="submit"
                disabled={loading || !description.trim()}
                className="btn btn-primary btn-sm text-xs font-bold flex items-center gap-1.5"
              >
                {loading ? (
                  <span>Lodging Grievance...</span>
                ) : (
                  <>
                    <Send className="w-3.5 h-3.5" />
                    <span>Lodge Statutory Ticket</span>
                  </>
                )}
              </button>
            </div>
          </form>
        )}
      </div>
    </div>
  );
}
