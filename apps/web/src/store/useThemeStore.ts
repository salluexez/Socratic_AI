import { create } from 'zustand';

export interface ThemePalette {
  key: string;
  name: string;
  scheme: 'dark' | 'light';
  background: string;
  surface: string;
  surfaceAlt: string;
  foreground: string;
  muted: string;
  accent: string;
  secondary: string;
  accentSoft: string;
  border: string;
  cardBase: string;
  cardGlow: string;
  cardPattern: 'grid' | 'stripes' | 'rings' | 'mesh' | 'paper';
}

export const themes: Record<string, ThemePalette> = {
  auroraGrid: {
    key: 'auroraGrid',
    name: 'Aurora Grid',
    scheme: 'dark',
    background: '#09131F',
    surface: '#112032',
    surfaceAlt: '#193149',
    foreground: '#EAF6FF',
    muted: '#8EA8C0',
    accent: '#53D1FF',
    secondary: '#58F7C3',
    accentSoft: 'rgba(83, 209, 255, 0.22)',
    border: '#28435F',
    cardBase: '#14263A',
    cardGlow: 'rgba(83, 209, 255, 0.45)',
    cardPattern: 'grid',
  },
  emberCircuit: {
    key: 'emberCircuit',
    name: 'Ember Circuit',
    scheme: 'dark',
    background: '#160F11',
    surface: '#24191D',
    surfaceAlt: '#322228',
    foreground: '#FFF2EE',
    muted: '#C8A19A',
    accent: '#FF8A5B',
    secondary: '#FFCD57',
    accentSoft: 'rgba(255, 138, 91, 0.24)',
    border: '#4C3338',
    cardBase: '#2E1F24',
    cardGlow: 'rgba(255, 138, 91, 0.42)',
    cardPattern: 'stripes',
  },
  jadeTerminal: {
    key: 'jadeTerminal',
    name: 'Jade Terminal',
    scheme: 'dark',
    background: '#081613',
    surface: '#112421',
    surfaceAlt: '#17322D',
    foreground: '#E8FFF8',
    muted: '#84B7AB',
    accent: '#3DE8B4',
    secondary: '#7AF5D4',
    accentSoft: 'rgba(61, 232, 180, 0.22)',
    border: '#2A4D45',
    cardBase: '#16312B',
    cardGlow: 'rgba(61, 232, 180, 0.42)',
    cardPattern: 'grid',
  },
  cobaltSignal: {
    key: 'cobaltSignal',
    name: 'Cobalt Signal',
    scheme: 'dark',
    background: '#0E1224',
    surface: '#171E39',
    surfaceAlt: '#222B4E',
    foreground: '#EDF0FF',
    muted: '#9EA8D8',
    accent: '#7DA2FF',
    secondary: '#5BE2FF',
    accentSoft: 'rgba(125, 162, 255, 0.24)',
    border: '#36436D',
    cardBase: '#1F2950',
    cardGlow: 'rgba(91, 226, 255, 0.4)',
    cardPattern: 'rings',
  },
  carbonRose: {
    key: 'carbonRose',
    name: 'Carbon Rose',
    scheme: 'dark',
    background: '#141116',
    surface: '#211C27',
    surfaceAlt: '#2D2435',
    foreground: '#F8EDFF',
    muted: '#B59AC4',
    accent: '#F29AD8',
    secondary: '#A3B5FF',
    accentSoft: 'rgba(242, 154, 216, 0.22)',
    border: '#45394E',
    cardBase: '#31293A',
    cardGlow: 'rgba(242, 154, 216, 0.4)',
    cardPattern: 'mesh',
  },
  arcticPaper: {
    key: 'arcticPaper',
    name: 'Arctic Paper',
    scheme: 'light',
    background: '#F2F7FC',
    surface: '#FFFFFF',
    surfaceAlt: '#E8EFF7',
    foreground: '#132136',
    muted: '#5E7694',
    accent: '#2E7BFF',
    secondary: '#00A7C8',
    accentSoft: 'rgba(46, 123, 255, 0.14)',
    border: '#C6D7EA',
    cardBase: '#E8EEF6',
    cardGlow: 'rgba(46, 123, 255, 0.28)',
    cardPattern: 'paper',
  },
  sandstoneInk: {
    key: 'sandstoneInk',
    name: 'Sandstone Ink',
    scheme: 'light',
    background: '#FAF5EC',
    surface: '#FFFDF8',
    surfaceAlt: '#EFE6D6',
    foreground: '#2C2216',
    muted: '#7E6D57',
    accent: '#C7642E',
    secondary: '#3D8B73',
    accentSoft: 'rgba(199, 100, 46, 0.16)',
    border: '#DCCBB0',
    cardBase: '#EFE3CF',
    cardGlow: 'rgba(199, 100, 46, 0.27)',
    cardPattern: 'paper',
  },
  midnightNeon: {
    key: 'midnightNeon',
    name: 'Midnight Neon',
    scheme: 'dark',
    background: '#080A13',
    surface: '#111525',
    surfaceAlt: '#1A2140',
    foreground: '#F5F7FF',
    muted: '#8C97BF',
    accent: '#7C5CFF',
    secondary: '#00E2FF',
    accentSoft: 'rgba(124, 92, 255, 0.23)',
    border: '#2D3762',
    cardBase: '#1A2141',
    cardGlow: 'rgba(124, 92, 255, 0.42)',
    cardPattern: 'mesh',
  },
  volcanicAsh: {
    key: 'volcanicAsh',
    name: 'Volcanic Ash',
    scheme: 'dark',
    background: '#120D0C',
    surface: '#211816',
    surfaceAlt: '#32221E',
    foreground: '#FDF1EB',
    muted: '#BCA099',
    accent: '#FF6A3D',
    secondary: '#FFC55A',
    accentSoft: 'rgba(255, 106, 61, 0.24)',
    border: '#4D342D',
    cardBase: '#372722',
    cardGlow: 'rgba(255, 106, 61, 0.42)',
    cardPattern: 'stripes',
  },
  velvetOrbit: {
    key: 'velvetOrbit',
    name: 'Velvet Orbit',
    scheme: 'dark',
    background: '#130F1E',
    surface: '#20192D',
    surfaceAlt: '#2C2240',
    foreground: '#F3ECFF',
    muted: '#AB9BC8',
    accent: '#B388FF',
    secondary: '#F978C3',
    accentSoft: 'rgba(179, 136, 255, 0.25)',
    border: '#43345C',
    cardBase: '#302746',
    cardGlow: 'rgba(249, 120, 195, 0.34)',
    cardPattern: 'rings',
  },
  solarDune: {
    key: 'solarDune',
    name: 'Solar Dune',
    scheme: 'light',
    background: '#FFF6E8',
    surface: '#FFFDF7',
    surfaceAlt: '#F7E9CF',
    foreground: '#2D2113',
    muted: '#836A4A',
    accent: '#D97A1E',
    secondary: '#FFD166',
    accentSoft: 'rgba(217, 122, 30, 0.17)',
    border: '#E3C89D',
    cardBase: '#F6E4C1',
    cardGlow: 'rgba(217, 122, 30, 0.28)',
    cardPattern: 'paper',
  },
  mintBlueprint: {
    key: 'mintBlueprint',
    name: 'Mint Blueprint',
    scheme: 'light',
    background: '#EEF9F6',
    surface: '#FCFFFE',
    surfaceAlt: '#DDEFEA',
    foreground: '#14322D',
    muted: '#547A72',
    accent: '#0E9F8A',
    secondary: '#24C2B3',
    accentSoft: 'rgba(14, 159, 138, 0.16)',
    border: '#B8D9D2',
    cardBase: '#D7EDE7',
    cardGlow: 'rgba(14, 159, 138, 0.25)',
    cardPattern: 'grid',
  },
  noirCinema: {
    key: 'noirCinema',
    name: 'Noir Cinema',
    scheme: 'dark',
    background: '#0B0D11',
    surface: '#141921',
    surfaceAlt: '#1E2531',
    foreground: '#ECF1F8',
    muted: '#8C99AA',
    accent: '#E6B673',
    secondary: '#9FB7D6',
    accentSoft: 'rgba(230, 182, 115, 0.2)',
    border: '#313B4A',
    cardBase: '#212A38',
    cardGlow: 'rgba(230, 182, 115, 0.28)',
    cardPattern: 'mesh',
  },
  githubDark: {
    key: 'githubDark',
    name: 'GitHub Dark',
    scheme: 'dark',
    background: '#010409',
    surface: '#0d1117',
    surfaceAlt: '#161b22',
    foreground: '#c9d1d9',
    muted: '#8b949e',
    accent: '#58a6ff',
    secondary: '#3fb950',
    accentSoft: 'rgba(88, 166, 255, 0.12)',
    border: '#30363d',
    cardBase: '#0d1117',
    cardGlow: 'rgba(88, 166, 255, 0.25)',
    cardPattern: 'grid',
  },
  githubDimmed: {
    key: 'githubDimmed',
    name: 'GitHub Dimmed',
    scheme: 'dark',
    background: '#22272e',
    surface: '#2d333b',
    surfaceAlt: '#373e47',
    foreground: '#adbac7',
    muted: '#768390',
    accent: '#539bf5',
    secondary: '#57ab5a',
    accentSoft: 'rgba(83, 155, 245, 0.15)',
    border: '#444c56',
    cardBase: '#22272e',
    cardGlow: 'rgba(83, 155, 245, 0.3)',
    cardPattern: 'mesh',
  },
  githubLight: {
    key: 'githubLight',
    name: 'GitHub Light',
    scheme: 'light',
    background: '#ffffff',
    surface: '#f6f8fa',
    surfaceAlt: '#eff2f5',
    foreground: '#1f2328',
    muted: '#656d76',
    accent: '#0969da',
    secondary: '#1a7f37',
    accentSoft: 'rgba(9, 105, 218, 0.12)',
    border: '#d0d7de',
    cardBase: '#f6f8fa',
    cardGlow: 'rgba(9, 105, 218, 0.2)',
    cardPattern: 'paper',
  },
};

interface ThemeState {
  activeTheme: string;
  setTheme: (key: string) => void;
  hydrate: () => void;
}

function applyTheme(palette: ThemePalette) {
  const root = document.documentElement;
  root.style.colorScheme = palette.scheme;
  root.style.setProperty('--background', palette.background);
  root.style.setProperty('--surface', palette.surface);
  root.style.setProperty('--surface-alt', palette.surfaceAlt);
  root.style.setProperty('--foreground', palette.foreground);
  root.style.setProperty('--muted', palette.muted);
  root.style.setProperty('--accent', palette.accent);
  root.style.setProperty('--secondary', palette.secondary);
  root.style.setProperty('--accent-soft', palette.accentSoft);
  root.style.setProperty('--border', palette.border);
}

export const useThemeStore = create<ThemeState>((set) => ({
  activeTheme: 'githubDark',
  setTheme: (key: string) => {
    const palette = themes[key];
    if (!palette) return;
    applyTheme(palette);
    localStorage.setItem('socratic-theme', key);
    set({ activeTheme: key });
  },
  hydrate: () => {
    const stored = localStorage.getItem('socratic-theme') || 'githubDark';
    const palette = themes[stored] || themes.githubDark;
    applyTheme(palette);
    set({ activeTheme: palette.key });
  },
}));
