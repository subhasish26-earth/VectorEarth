import React, { createContext, useContext, useState, useEffect } from 'react';

const LanguageContext = createContext(null);

export const SUPPORTED_LANGUAGES = [
  { code: 'OR', label: 'Odia', native: 'ଓଡ଼ିଆ' },
  { code: 'EN', label: 'English', native: 'English' },
  { code: 'HI', label: 'Hindi', native: 'हिन्दी' },
  { code: 'BN', label: 'Bengali', native: 'বাংলা' },
  { code: 'TE', label: 'Telugu', native: 'తెలుగు' },
  { code: 'TA', label: 'Tamil', native: 'தமிழ்' },
  { code: 'MR', label: 'Marathi', native: 'मराठी' },
  { code: 'GU', label: 'Gujarati', native: 'ગુજરાતી' },
  { code: 'KN', label: 'Kannada', native: 'ಕನ್ನಡ' },
  { code: 'ML', label: 'Malayalam', native: 'മലയാളം' },
  { code: 'PA', label: 'Punjabi', native: 'ਪੰਜਾਬੀ' },
  { code: 'UR', label: 'Urdu', native: 'اردو' },
  { code: 'AS', label: 'Assamese', native: 'অসমীয়া' },
  { code: 'SA', label: 'Sanskrit', native: 'संस्कृतम्' },
];

import { TRANSLATIONS } from '../data/translations';
export { TRANSLATIONS };

export function LanguageProvider({ children }) {
  const [lang, setLangState] = useState(() => {
    return localStorage.getItem('gov_language') || 'EN';
  });

  const setLang = (newLang) => {
    localStorage.setItem('gov_language', newLang);
    setLangState(newLang);
  };

  const t = (key, fallback) => {
    const currentDict = TRANSLATIONS[lang] || TRANSLATIONS.EN;
    if (currentDict && currentDict[key] !== undefined && currentDict[key] !== '') return currentDict[key];
    if (TRANSLATIONS.EN && TRANSLATIONS.EN[key] !== undefined && TRANSLATIONS.EN[key] !== '') return TRANSLATIONS.EN[key];
    return fallback !== undefined ? fallback : key;
  };

  return (
    <LanguageContext.Provider value={{ lang, setLang, t }}>
      {children}
    </LanguageContext.Provider>
  );
}

export function useLanguage() {
  const context = useContext(LanguageContext);
  if (!context) {
    throw new Error('useLanguage must be used within a LanguageProvider');
  }
  return context;
}
