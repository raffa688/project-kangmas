import React, { useState } from 'react';
import { 
  BuildingOfficeIcon, 
  HomeModernIcon, 
  WrenchIcon, 
  BoltIcon, 
  VideoCameraIcon, 
  HomeIcon
} from '@heroicons/react/24/outline';

export default function LayananSection() {
  const [activeTab, setActiveTab] = useState('Perumahan');

  const services = [
    {
      id: 1,
      name: 'Service AC',
      desc: 'Untuk layanan AC anda sudah tidak terawat dengan baik, kami siap melayani air AC anda.',
      icon: <BoltIcon className="h-6 w-6 text-primary" />,
    },
    {
      id: 2,
      name: 'Kelistrikan Dan Kabel',
      desc: 'Layanan ini dkhusus untuk Anda yang mempunyai masalah Kabel Dan Listrik di rumah.',
      icon: <BoltIcon className="h-6 w-6 text-primary" />,
    },
    {
      id: 3,
      name: 'Pembangunan Umum',
      desc: 'Sama dengan nama nya kami siap membantu anda di bidang pertukangan.',
      icon: <BuildingOfficeIcon className="h-6 w-6 text-primary" />,
    },
    {
      id: 4,
      name: 'Sistem Keamanan',
      desc: 'Kami siap memasang alat sistem keamanan rumah anda dengan rapi.',
      icon: <VideoCameraIcon className="h-6 w-6 text-primary" />,
    },
    {
      id: 5,
      name: 'Perawatan Bangunan',
      desc: 'Jika Anda ingin merawat rumah, baik perawatan skala kecil, kami bisa melayani anda.',
      icon: <WrenchIcon className="h-6 w-6 text-primary" />,
    },
    {
      id: 6,
      name: 'Perluasan Rumah',
      desc: 'Jika area rumah Anda ada keinginan/mengembang, kami bisa merawat proyek anda.',
      icon: <HomeIcon className="h-6 w-6 text-primary" />,
    },
  ];

  return (
    <section id="layanan" className="w-full bg-white py-20">
      <div className="kangmas-container">
        <div className="text-center mb-12">
          <div className="inline-block text-primary text-sm font-semibold mb-2">Layanan Kami</div>
          <h2 className="text-3xl font-bold text-gray-900">Spesialisasi Kami</h2>
          <p className="text-gray-600 mt-4 max-w-2xl mx-auto">
            Berbagai solusi layanan tukang profesional khusus untuk kebutuhan perumahan Anda.
          </p>
        </div>

        {/* Responsive Tabs Grid */}
        <div className="flex flex-col sm:flex-row justify-center gap-2 sm:gap-4 mb-8">
          <button 
            onClick={() => setActiveTab('Perumahan')}
            className={`px-4 sm:px-6 py-3 rounded-lg font-semibold flex items-center justify-center gap-2 transition ${activeTab === 'Perumahan' ? 'bg-primary text-gray-900 shadow' : 'border border-gray-300 text-gray-700 hover:bg-gray-50'}`}
          >
            <HomeModernIcon className="h-5 w-5" /> Perumahan
          </button>
        </div>

        {/* 1 col on mobile, 2 on tablet, 3 on desktop */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mt-12">
          {services.map((service) => (
            <div key={service.id} className="bg-dark text-white p-8 rounded-xl hover:-translate-y-1 transition duration-300 h-full flex flex-col">
              <div className="mb-6">{service.icon}</div>
              <h3 className="text-xl font-bold mb-4 text-primary">{service.name}</h3>
              <p className="text-gray-400 text-sm flex-grow">{service.desc}</p>
              <div className="mt-8 flex justify-end">
                  <div className="w-8 h-8 rounded-full border border-gray-600 flex items-center justify-center text-gray-400 hover:text-white hover:border-white cursor-pointer transition">
                    →
                  </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
