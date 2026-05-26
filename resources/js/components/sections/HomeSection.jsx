import React from 'react';
import { ArrowRightIcon, CheckCircleIcon } from '@heroicons/react/24/outline';
import { Link } from 'react-router-dom';

export default function HomeSection() {
  return (
    <section id="home" className="w-full pt-16">
      {/* Hero Section */}
      <div className="bg-gradient-to-br from-gray-900 to-gray-800 py-20 relative overflow-hidden text-white h-[600px] flex items-center">
         <div className="absolute inset-0 bg-black/40 z-10"></div>
         {/* <img src="https://images.unsplash.com/photo-1541888086225-ee5a006db235?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" alt="" className="absolute inset-0 w-full h-full object-cover z-0" /> */}
         
         <div className="kangmas-container relative z-20 flex flex-col items-center justify-center h-full text-center mt-8 md:mt-0">
            <div className="max-w-4xl mx-auto flex flex-col items-center">
              <div className="inline-flex items-center gap-2 bg-primary/20 text-primary border border-primary/50 px-4 py-1.5 rounded-full text-sm font-bold mb-6 tracking-wider uppercase backdrop-blur-sm shadow-sm">
                 KANGMAS: Cepat, Aman, Terpercaya
              </div>
              <h1 className="text-5xl md:text-7xl font-extrabold font-sans tracking-tight mb-8 leading-tight drop-shadow-sm">
                Solusi Ahli Pertukangan Anda
              </h1>
              <p className="text-lg md:text-xl text-gray-200 mb-10 max-w-2xl font-medium drop-shadow-sm">
                Hubungkan diri Anda dengan mitra tukang profesional bersertifikat. Solusi perbaikan cepat, transparan, dan hasil yang memuaskan.
              </p>
              <a href="#layanan" className="inline-flex items-center gap-2 bg-primary text-gray-900 font-bold px-8 py-4 rounded-xl hover:bg-primary-hover transition-all duration-300 shadow-lg hover:shadow-xl hover:-translate-y-1">
                Jelajahi Layanan <ArrowRightIcon className="h-5 w-5" />
              </a>
            </div>
         </div>
      </div>

      {/* Feature / Highlight */}
      <div className="bg-white py-20">
         <div className="kangmas-container flex flex-col md:flex-row items-center gap-12">
            <div className="md:w-1/2 flex justify-center">
              <img src="https://images.unsplash.com/photo-1503387762-592deb58ef4e?q=80&w=1331&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" alt="Worker Smiling" className="max-w-sm rounded-[3rem] shadow-2xl" />
            </div>
            <div className="md:w-1/2">
              <div className="inline-flex items-center gap-2 text-primary font-bold text-sm mb-4">
                <span>👋</span> Selamat Datang Di KANGMAS
              </div>
              <h2 className="text-4xl font-bold text-gray-900 mb-6 leading-tight">
                Standar Kualitas & Kepastian Harga
              </h2>
              <p className="text-gray-600 mb-6 font-medium">
                Punya masalah kelistrikan, kerusakan pipa, hingga renovasi berat? KANGMAS selalu sedia menghubungkan Anda dengan tukang tersertifikasi untuk hasil yang presisi dan transparan.
              </p>
              
              <a href="#tentang" className="inline-block bg-primary text-gray-900 font-bold px-6 py-3 rounded hover:bg-primary-hover transition shadow-sm">
                Pelajari KANGMAS
              </a>
            </div>
         </div>
      </div>
    </section>
  );
}
