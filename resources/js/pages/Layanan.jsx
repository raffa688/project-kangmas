import React, { useState } from 'react';
import { 
  BuildingOfficeIcon, 
  HomeModernIcon, 
  WrenchIcon, 
  BoltIcon, 
  VideoCameraIcon, 
  HomeIcon,
  CheckCircleIcon
} from '@heroicons/react/24/outline';

export default function Layanan() {
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
    <div className="w-full">
      {/* Top Banner */}
      <div className="bg-gradient-to-r from-gray-700 to-gray-500 py-20 text-center relative w-full h-[250px] flex items-center justify-center">
         <div className="absolute inset-0 bg-primary/20 mix-blend-multiply"></div>
         <h1 className="text-4xl font-bold text-white relative z-10">Layanan Kami</h1>
      </div>

      {/* Jasa Utama */}
      <div className="bg-primary py-16 -mt-10 relative z-20">
        <div className="kangmas-container text-center">
          <h2 className="text-3xl font-bold text-gray-900 mb-4">Jasa Utama KANGMAS</h2>
          <p className="text-gray-800 mb-8 max-w-2xl mx-auto">
            KANGMAS adalah platform handal berbagai solusi pelayanan tukang profesional. Kami siap memberikan layanan komprehensif dari awal hingga akhir.
          </p>

          <div className="flex justify-center gap-4 mb-8">
            <button 
              onClick={() => setActiveTab('Perumahan')}
              className={`px-6 py-3 rounded-lg font-semibold flex items-center gap-2 ${activeTab === 'Perumahan' ? 'bg-white text-gray-900 shadow' : 'border border-gray-900 text-gray-900'}`}
            >
              <HomeModernIcon className="h-5 w-5" /> Perumahan
            </button>
          </div>

          {/* Tab Content Card */}
          <div className="bg-white rounded-xl shadow-lg max-w-4xl mx-auto flex flex-col md:flex-row overflow-hidden text-left">
            <div className="p-8 md:w-1/2 flex flex-col justify-center">
              <div className="inline-block bg-primary/20 text-primary px-3 py-1 rounded-full text-sm font-semibold mb-4 w-max">
                Bagian Komersial
              </div>
              <h3 className="text-2xl font-bold text-gray-900 mb-4">{activeTab}</h3>
              <p className="text-gray-600 mb-6 text-sm">
                KANGMAS memberikan maintenance/kelistrikan untuk komersial bangunan anda, perdagangan, dan properti Anda yang berada dalam wilayah layanan. Proses kami dilakukan proporsional, dari awal hingga akhir...
              </p>
              <button className="bg-primary text-gray-900 font-semibold px-6 py-2 rounded shadow hover:bg-primary-hover w-max">
                INFO MASALAH LANJUT
              </button>
            </div>
            <div className="md:w-1/2 bg-gray-200">
               {/* Placeholder for real image */}
              <img src="https://images.unsplash.com/photo-1541888086225-ee5a006db235?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80" alt="Worker" className="w-full h-full object-cover" />
            </div>
          </div>
        </div>
      </div>

      {/* Grid Layanan List */}
      <div className="py-20 bg-white">
        <div className="kangmas-container">
          <div className="text-center mb-12">
            <div className="inline-block text-primary text-sm font-semibold mb-2">Layanan Kami</div>
            <h2 className="text-3xl font-bold text-gray-900">Layanan Kami</h2>
            <p className="text-gray-600 mt-4 max-w-2xl mx-auto">
              Ada banyak utilitas yang kami sediakan dari sekedar produk layanan kesehatan / kebugaran untuk mendapatkan tenaga siap membantu.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {services.map((service) => (
              <div key={service.id} className="bg-dark text-white p-8 rounded-xl hover:-translate-y-1 transition duration-300">
                <div className="mb-6">{service.icon}</div>
                <h3 className="text-xl font-bold mb-4 text-primary">{service.name}</h3>
                <p className="text-gray-400 text-sm">{service.desc}</p>
                <div className="mt-8 flex justify-end">
                   <div className="w-8 h-8 rounded-full border border-gray-600 flex items-center justify-center text-gray-400 hover:text-white hover:border-white cursor-pointer transition">
                     →
                   </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Bagaimana Kami Bekerja */}
      <div className="py-20 bg-gray-50">
        <div className="kangmas-container text-center">
            <div className="inline-block text-primary text-sm font-semibold mb-2">Layanan Kami</div>
            <h2 className="text-3xl font-bold text-gray-900 mb-4">Bagaimana Kami Bekerja</h2>
            <p className="text-gray-600 max-w-3xl mx-auto mb-12">
              Dan ini adalah segala bentuk layanan jasa KANGMAS untuk Anda dalam menjaga kemudahan di masa sekarang demi masa depan yang lebih baik.
            </p>

            <h3 className="text-2xl font-bold text-gray-900 mb-8">
              Kami Bisa Membantu Anda Dengan<br/>Berbagai Layanan Kami
            </h3>

            <div className="max-w-4xl mx-auto">
              {/* Illustration Placeholder */}
              <div className="w-full h-64 bg-gray-200 rounded-2xl mb-10 overflow-hidden flex items-center justify-center">
                 <img src="https://images.unsplash.com/photo-1504307651254-35680f356f12?ixlib=rb-1.2.1&auto=format&fit=crop&w=1200&q=80" alt="Team of builders" className="w-full h-full object-cover" />
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-4 text-left px-8">
                 {[
                   'Perbaikan Umum', 'Perawatan Rumah/Bangunan',
                   'Perbaikan Kelistrikan', 'Instalasi Perawatan Bangunan',
                   'Perbaikan Saluran Air', 'Sistem Pembangunan/Renovasi',
                   'Pengecatan Bangunan', 'Perbaikan dan Perawatan AC',
                   'Pembangunan Bangunan', 'Pembuangan Sampah',
                   'Angkat Dan Pindah Barang', 'Layanan Keamanan'
                 ].map((item, idx) => (
                   <div key={idx} className="flex items-center gap-3">
                     <CheckCircleIcon className="h-6 w-6 text-primary" />
                     <span className="text-gray-700 font-medium">{item}</span>
                   </div>
                 ))}
              </div>
            </div>
            
            <p className="mt-16 text-gray-600 max-w-2xl mx-auto font-medium">
              Kami akan terus menambah variasi dan berbagai divisi layanan untuk mempermudah anda. Kami sangat terbuka untuk mengapresiasi segala bentuk saran dari anda!
            </p>
        </div>
      </div>
    </div>
  );
}
