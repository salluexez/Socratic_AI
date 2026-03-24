import Link from 'next/link';

export default function HomePage() {
  return (
    <div className="flex flex-col min-h-screen">
      {/* Navigation */}
      <nav className="flex items-center justify-between px-8 py-6 glass sticky top-0 z-50">
        <div className="text-2xl font-bold tracking-tight text-slate-900 font-inter">
          Socratic <span className="text-blue-600">AI</span>
        </div>
        <div className="space-x-8 text-sm font-medium text-slate-600">
          <Link href="#how-it-works" className="hover:text-blue-600 transition-colors">How it Works</Link>
          <Link href="/login" className="px-5 py-2.5 rounded-full bg-slate-900 text-white hover:bg-slate-800 transition-all shadow-tonal">
            Get Started
          </Link>
        </div>
      </nav>

      {/* Hero Section */}
      <main className="flex-grow flex flex-col items-center justify-center px-4 py-20 bg-gradient-to-b from-white to-slate-50">
        <div className="max-w-4xl text-center space-y-8 animate-in fade-in slide-in-from-bottom-5 duration-1000">
          <h1 className="text-6xl md:text-7xl font-bold tracking-tight text-slate-900 leading-[1.1]">
            Learn Through <br />
            <span className="text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-indigo-600">
              Personal Discovery
            </span>
          </h1>
          <p className="text-xl text-slate-600 max-w-2xl mx-auto leading-relaxed">
            Our Socratic AI doesn't just give you answers. It asks the right questions 
            to help you uncover the solution yourself, building deeper understanding.
          </p>
          <div className="flex items-center justify-center gap-4 pt-4">
            <Link href="/login" className="px-8 py-4 rounded-full bg-blue-600 text-white text-lg font-semibold hover:bg-blue-700 transition-all shadow-xl hover:scale-105 active:scale-95">
              Start Learning Now
            </Link>
            <Link href="#how-it-works" className="px-8 py-4 rounded-full border border-slate-200 text-slate-900 text-lg font-semibold hover:bg-slate-50 transition-all">
              See How It Works
            </Link>
          </div>
        </div>

        {/* Feature Grid */}
        <div id="how-it-works" className="max-w-6xl w-full mt-32 grid grid-cols-1 md:grid-cols-3 gap-8">
          <div className="p-8 rounded-3xl bg-white border border-slate-100 shadow-tonal space-y-4">
            <div className="w-12 h-12 rounded-2xl bg-blue-50 flex items-center justify-center text-blue-600 font-bold text-xl">1</div>
            <h3 className="text-xl font-bold text-slate-900">Choose a Subject</h3>
            <p className="text-slate-600">Select between Physics, Chemistry, Math, or Biology to focus your study session.</p>
          </div>
          <div className="p-8 rounded-3xl bg-white border border-slate-100 shadow-tonal space-y-4">
            <div className="w-12 h-12 rounded-2xl bg-indigo-50 flex items-center justify-center text-indigo-600 font-bold text-xl">2</div>
            <h3 className="text-xl font-bold text-slate-900">Interactive Dialogue</h3>
            <p className="text-slate-600">Engage in a back-and-forth conversation. Our AI adapts to your level of knowledge.</p>
          </div>
          <div className="p-8 rounded-3xl bg-white border border-slate-100 shadow-tonal space-y-4">
            <div className="w-12 h-12 rounded-2xl bg-purple-50 flex items-center justify-center text-purple-600 font-bold text-xl">3</div>
            <h3 className="text-xl font-bold text-slate-900">Master Concepts</h3>
            <p className="text-slate-600">Uncover solutions through scaffolding hints and step-by-step logical guidance.</p>
          </div>
        </div>
      </main>

      <footer className="py-12 border-t border-slate-100 bg-white">
        <div className="max-w-6xl mx-auto px-4 flex flex-col md:flex-row items-center justify-between text-slate-500 text-sm">
          <div>© 2026 Socratic AI Teaching Assistant. Built for mastery.</div>
          <div className="flex gap-8 mt-4 md:mt-0">
            <Link href="#" className="hover:text-blue-600">Terms</Link>
            <Link href="#" className="hover:text-blue-600">Privacy</Link>
          </div>
        </div>
      </footer>
    </div>
  );
}
