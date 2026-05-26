import React from 'react';
import { ArrowRightIcon, CheckCircleIcon } from '@heroicons/react/24/outline';
import { Link } from 'react-router-dom';

export default function Home() {
  return (
    <div className="w-full">
      {/* Hero Section */}
      <div className="bg-gradient-to-br from-gray-900 to-gray-800 py-20 relative overflow-hidden text-white h-[600px] flex items-center">
        <div className="absolute inset-0 bg-black/40 z-10"></div>
        {/* Background Image Placeholder */}
        <img src="https://images.unsplash.com/photo-1541888086225-ee5a006db235?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" alt="Background" className="absolute inset-0 w-full h-full object-cover z-0" />

        <div className="kangmas-container relative z-20 flex flex-col md:flex-row items-center">
          <div className="md:w-1/2">
            <div className="inline-flex items-center gap-2 bg-primary/20 text-primary border border-primary/50 px-4 py-1 rounded-full text-xs font-bold mb-6 tracking-wider">
              KAMI ADALAH TENAGA KERJA PROFESIONAL
            </div>
            <h1 className="text-5xl md:text-6xl font-bold font-sans tracking-tight mb-6 leading-tight">
              Kami Adalah Tenaga<br />Kerja Profesional
            </h1>
            <button className="bg-primary text-gray-900 font-bold px-8 py-3 rounded-lg hover:bg-primary-hover transition flex items-center gap-2">
              Layanan Kami <ArrowRightIcon className="h-5 w-5" />
            </button>
          </div>
        </div>
      </div>

      {/* Feature / Highlight */}
      <div className="bg-white py-20">
        <div className="kangmas-container flex flex-col md:flex-row items-center gap-12">
          <div className="md:w-1/2 flex justify-center">
            <img src="https://images.unsplash.com/photo-1503387762-592deb58ef4e?q=80&w=1331&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
              className="max-w-sm rounded-[3rem] shadow-2xl" />
          </div>
          <div className="md:w-1/2">
            <div className="inline-flex items-center gap-2 text-primary font-bold text-sm mb-4">
              <span>👋</span> Selamat Datang Di KANGMAS
            </div>
            <h2 className="text-4xl font-bold text-gray-900 mb-6 leading-tight">
              Kami Mengutamakan Masa Depan Anda
            </h2>
            <p className="text-gray-600 mb-6 font-medium">
              Di sini kami menawarkan berbagai jenis tenaga kerja terampil khusus untuk berbagai pelayanan. Kami pastikan kami akan mengirim tenaga kerja yang mumpuni dengan spesifikasi yang anda perlukan.
            </p>
            <p className="text-gray-600 text-sm mb-8">
              Dengan menggunakan platform kami sebagai media anda, kami tidak akan memungut biaya bulanan pada anda. Kami yakin TUKANG di Indonesia punya nilai jual lebih di masa yang akan datang.
            </p>

            <Link to="/tentang" className="bg-primary text-gray-900 font-bold px-6 py-3 rounded hover:bg-primary-hover transition">
              Lebih Lanjut
            </Link>
          </div>
        </div>
      </div>

      {/* Mengapa Kami */}
      <div className="bg-gray-50 py-20">
        <div className="kangmas-container flex flex-col md:flex-row gap-12">
          <div className="md:w-1/2 relative">
            <div className="bg-dark/5 p-8 rounded-2xl w-3/4 absolute -left-4 top-10 h-full -z-0"></div>
            <img src="https://images.unsplash.com/photo-1503387762-592deb58ef4e?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80" alt="Construction" className="rounded-2xl shadow-lg relative z-10" />
            <div className="absolute bottom-10 right-10 bg-primary/95 backdrop-blur text-gray-900 px-6 py-4 rounded-xl shadow-xl z-20 font-bold border border-yellow-400">
              <ul className="space-y-3">
                <li className="flex justify-between border-b border-gray-900/10 pb-2"><span className="w-20">2000+</span> <span>Pekerjaan Selesai</span></li>
                <li className="flex justify-between border-b border-gray-900/10 pb-2"><span className="w-20">100+</span> <span>Pekerja</span></li>
                <li className="flex justify-between border-b border-gray-900/10 pb-2"><span className="w-20">100+</span> <span>Partner Kami</span></li>
                <li className="flex justify-between"><span className="w-20">1000+</span> <span>Pelanggan Puas</span></li>
              </ul>
            </div>
          </div>
          <div className="md:w-1/2 flex flex-col justify-center">
            <div className="inline-flex items-center gap-2 text-primary font-bold text-sm mb-4">
              ✅ Alasan Memilih KANGMAS
            </div>
            <h2 className="text-3xl font-bold text-gray-900 mb-6 leading-tight">
              Beberapa Alasan Kenapa Kamu Harus Menggunakan Kami
            </h2>
            <p className="text-gray-600 mb-8">
              Mungkin banyak dari kamu mencari referensi penyedia layanan pekerjaan yang menjamin keahlian TUKANG. Namun kami pastikan TUKANG yang ada di kami memiliki standarisasi tersendiri. Diantaranya:
            </p>
            <div className="space-y-6">
              <div className="flex gap-4">
                <div className="mt-1"><CheckCircleIcon className="w-6 h-6 text-primary" /></div>
                <div>
                  <h4 className="font-bold text-gray-900">Pengalaman Yang Kuat & Bangun</h4>
                  <p className="text-sm text-gray-600 mt-1">KANGMAS adalah platform dari perusahaan yang bisa memberikan kriteria pengalaman dan menjamin tukang.</p>
                </div>
              </div>
              <div className="flex gap-4">
                <div className="mt-1"><CheckCircleIcon className="w-6 h-6 text-primary" /></div>
                <div>
                  <h4 className="font-bold text-gray-900">Tenaga Kerja Yang Sudah Punya Sertifikat</h4>
                  <p className="text-sm text-gray-600 mt-1">Untuk menyeleksi TUKANG melalui aplikasi, kami pastikan TUKANG tersebut lolos standarisasi kami.</p>
                </div>
              </div>
              <div className="flex gap-4">
                <div className="mt-1"><CheckCircleIcon className="w-6 h-6 text-primary" /></div>
                <div>
                  <h4 className="font-bold text-gray-900">Harga Yang Ditetapkan</h4>
                  <p className="text-sm text-gray-600 mt-1">Estimasi biaya perbaikan dan pemasangan yang kami berikan pasti lebih transparan dan lebih masuk di akal.</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

    </div>
  );
}
