import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { WrenchScrewdriverIcon, CheckCircleIcon } from '@heroicons/react/24/outline';
import api from '../services/api';
import { GoogleMap, useLoadScript, Marker } from '@react-google-maps/api';

const mapContainerStyle = {
  width: '100%',
  height: '300px',
  borderRadius: '0.5rem',
};

const defaultCenter = {
  lat: -6.974001,
  lng: 107.630348,
};

/**
 * RegisterTukang — Pure UI Component (Multi-step Registration Form)
 * 
 * @param {Function} onSubmit - Callback when form is submitted. Receives FormData object.
 *                               Default: mock that simulates success (goes to step 5).
 */
export default function RegisterTukang({ onSubmit }) {
  const navigate = useNavigate();
  const { isLoaded, loadError } = useLoadScript({
    googleMapsApiKey: import.meta.env.VITE_GOOGLE_MAPS_API_KEY || '', 
  });
  const [step, setStep] = useState(1);
  const [loading, setLoading] = useState(false);
  const [formData, setFormData] = useState({
    name: '', email: '', phone: '', password: '', 
    kategori: 'Kelistrikan', experience: '', portofolio: null,
    ktp: null, selfie: null,
    locationType: 'manual', locationDetail: '', lat: null, lng: null
  });

  const handleChange = (e) => {
    const { name, value, files } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: files ? files[0] : value
    }));
  };

  const nextStep = () => setStep(prev => prev + 1);
  const prevStep = () => setStep(prev => prev - 1);

  const handleGetLocation = () => {
    if (!navigator.geolocation) {
      alert("Browser Anda tidak mendukung akses GPS.");
      return;
    }
    navigator.geolocation.getCurrentPosition(
      (position) => {
        setFormData(prev => ({
          ...prev,
          lat: position.coords.latitude,
          lng: position.coords.longitude
        }));
        alert(`Lokasi GPS berhasil dikunci: ${position.coords.latitude.toFixed(4)}, ${position.coords.longitude.toFixed(4)}`);
      },
      (error) => {
        alert("Gagal mengunci lokasi. Pastikan izin akses lokasi (Location Access) diaktifkan di browser Anda.");
      }
    );
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    
    try {
      const data = new FormData();
      Object.keys(formData).forEach(key => {
         if (formData[key] !== null) {
            data.append(key, formData[key]);
         }
      });

      // API Call to register tukang
      await api.post('/tukang/register', data, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      });

      if (onSubmit) {
        await onSubmit(data);
      }
      
      // Go to success step
      setStep(5);
    } catch (error) {
      console.error('Registration error:', error);
      const msg = error.response?.data?.message || error.message || 'Unknown error';
      alert("Terjadi kesalahan saat mendaftar: " + msg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col pt-10 pb-12 sm:px-6 lg:px-8 relative">
      {/* Tombol Back Explicit */}
      <button onClick={() => navigate('/')} className="absolute top-6 left-6 flex items-center gap-2 text-sm font-bold text-gray-700 hover:text-primary transition bg-white px-4 py-2 rounded-lg shadow-sm border border-gray-200 z-10">
         &larr; Kembali ke Beranda
      </button>

      {/* Header */}
      <div className="sm:mx-auto sm:w-full sm:max-w-md">
        <div className="flex justify-center gap-2 items-center text-primary mb-6 text-4xl font-extrabold cursor-pointer" onClick={() => navigate('/')}>
           <WrenchScrewdriverIcon className="h-10 w-10 text-gray-900" />
           <span className="text-gray-900 tracking-tight">KANGMAS</span>
        </div>
        {step < 5 && (
           <h2 className="mt-2 text-center text-2xl font-bold text-gray-900">
             Pendaftaran Mitra Tukang
           </h2>
        )}
      </div>

      <div className="mt-8 sm:mx-auto sm:w-full sm:max-w-xl">
        <div className="bg-white py-8 px-4 shadow sm:rounded-xl sm:px-10 border border-gray-100">
          
          {/* Progress Indicator */}
          {step < 5 && (
            <div className="mb-8 border-b border-gray-100 pb-6">
              <div className="flex justify-between items-center text-xs font-bold text-gray-400">
                <span className={step >= 1 ? 'text-primary' : ''}>1. Data Diri</span>
                <span className={step >= 2 ? 'text-primary' : ''}>2. Keahlian</span>
                <span className={step >= 3 ? 'text-primary' : ''}>3. Dokumen</span>
                <span className={step >= 4 ? 'text-primary' : ''}>4. Lokasi</span>
              </div>
              <div className="w-full bg-gray-200 h-2 mt-2 rounded-full overflow-hidden">
                 <div className="bg-primary h-full transition-all duration-300" style={{ width: `${(step / 4) * 100}%` }}></div>
              </div>
            </div>
          )}

          <form onSubmit={step === 4 ? handleSubmit : (e) => { e.preventDefault(); nextStep(); }}>
            
            {/* STEP 1: Data Diri */}
            {step === 1 && (
              <div className="space-y-5 flex flex-col animate-fadeIn">
                <div>
                  <label className="block text-sm font-semibold text-gray-700">Nama Lengkap Sesuai KTP</label>
                  <input required name="name" value={formData.name} onChange={handleChange} className="mt-1 w-full px-4 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-primary focus:border-primary outline-none" />
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-700">Email Aktif</label>
                  <input required type="email" name="email" value={formData.email} onChange={handleChange} className="mt-1 w-full px-4 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-primary focus:border-primary outline-none" />
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-700">Nomor WhatsApp</label>
                  <input required type="tel" name="phone" value={formData.phone} onChange={handleChange} className="mt-1 w-full px-4 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-primary focus:border-primary outline-none" />
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-700">Password</label>
                  <input required type="password" name="password" value={formData.password} onChange={handleChange} className="mt-1 w-full px-4 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-primary focus:border-primary outline-none" />
                </div>
              </div>
            )}

            {/* STEP 2: Data Keahlian */}
            {step === 2 && (
              <div className="space-y-5 animate-fadeIn">
                <div>
                  <label className="block text-sm font-semibold text-gray-700">Pilih Kategori Keahlian Utama</label>
                  <select name="kategori" value={formData.kategori} onChange={handleChange} className="mt-1 w-full px-4 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-primary focus:border-primary outline-none bg-white">
                    <option>Kelistrikan & Kabel</option>
                    <option>Pembangunan Bangunan</option>
                    <option>Service AC</option>
                    <option>Sistem Keamanan</option>
                    <option>Pengecatan & Dekorasi</option>
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-700">Lama Pengalaman (Tahun)</label>
                  <input required type="number" min="0" name="experience" value={formData.experience} onChange={handleChange} className="mt-1 w-full px-4 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-primary focus:border-primary outline-none" />
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-700">Upload Portofolio (PDF/Gambar) *Opsi</label>
                  <input type="file" name="portofolio" onChange={handleChange} className="mt-1 w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded file:border-0 file:text-sm file:font-semibold file:bg-primary file:text-gray-900 hover:file:bg-primary-hover" />
                </div>
              </div>
            )}

            {/* STEP 3: Verifikasi Dokumen */}
            {step === 3 && (
              <div className="space-y-6 animate-fadeIn">
                <div className="bg-yellow-50 p-4 rounded text-sm text-yellow-800 border border-yellow-200">
                   Pastikan foto dokumen jelas, tidak terpotong, dan tulisan terbaca sempurna.
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-700">Upload Foto KTP (*Wajib)</label>
                  <input required type="file" accept="image/*" name="ktp" onChange={handleChange} className="mt-1 w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded file:border-0 file:text-sm file:font-semibold file:bg-gray-100 file:text-gray-900 hover:file:bg-gray-200 border border-gray-200 p-1" />
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-700">Upload Selfie Dengan KTP (*Wajib)</label>
                  <input required type="file" accept="image/*" name="selfie" onChange={handleChange} className="mt-1 w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded file:border-0 file:text-sm file:font-semibold file:bg-gray-100 file:text-gray-900 hover:file:bg-gray-200 border border-gray-200 p-1" />
                </div>
              </div>
            )}

            {/* STEP 4: Lokasi */}
            {step === 4 && (
              <div className="space-y-6 animate-fadeIn">
                 <div>
                    <label className="block text-sm font-semibold text-gray-700 mb-2">Tentukan Titik Lokasi Rumah / Kos (Geser/Klik pada Peta)</label>
                    
                    <div className="mb-3">
                       <button type="button" onClick={handleGetLocation} className="text-sm bg-primary text-gray-900 font-bold px-4 py-2 rounded shadow-sm hover:bg-primary-hover transition flex items-center gap-2">
                          📍 Gunakan GPS Saat Ini
                       </button>
                    </div>

                    <div className="bg-gray-100 flex justify-center items-center rounded border border-gray-300 min-h-[300px] relative overflow-hidden">
                       {loadError ? (
                         <div className="text-red-500 font-bold">Error Loading Maps</div>
                       ) : !isLoaded ? (
                         <div className="text-gray-500 font-bold">Loading Map...</div>
                       ) : (
                         <GoogleMap
                           mapContainerStyle={mapContainerStyle}
                           zoom={15}
                           center={formData.lat && formData.lng ? { lat: formData.lat, lng: formData.lng } : defaultCenter}
                           onClick={(e) => {
                              setFormData(prev => ({
                                ...prev,
                                lat: e.latLng.lat(),
                                lng: e.latLng.lng()
                              }));
                           }}
                           options={{
                              disableDefaultUI: true,
                              zoomControl: true,
                           }}
                         >
                           {formData.lat && formData.lng && (
                              <Marker position={{ lat: formData.lat, lng: formData.lng }} />
                           )}
                         </GoogleMap>
                       )}
                       {!formData.lat && (
                          <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 bg-white/90 px-4 py-2 rounded shadow text-sm font-bold text-gray-800 pointer-events-none">
                             Klik peta untuk menandai lokasi
                          </div>
                       )}
                    </div>
                    {formData.lat && formData.lng ? (
                       <p className="text-xs text-green-600 mt-2 font-bold">✓ Koordinat terpilih: {formData.lat.toFixed(5)}, {formData.lng.toFixed(5)}</p>
                    ) : (
                       <p className="text-xs text-red-500 mt-2 font-bold">*Wajib mengklik lokasi pada peta</p>
                    )}
                 </div>

                 <div>
                    <label className="block text-sm font-semibold text-gray-700">Detail Alamat (Nomor Rumah / Patokan)</label>
                    <textarea required name="locationDetail" rows="3" value={formData.locationDetail} onChange={handleChange} className="mt-1 w-full px-4 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-primary focus:border-primary outline-none" placeholder="Contoh: Jl. Sukabirus No 10, rumah cat biru pagar hitam..." />
                 </div>
              </div>
            )}

            {/* STEP 5: Status Submit */}
            {step === 5 && (
               <div className="text-center py-6 animate-fadeIn">
                  <div className="mb-4 flex justify-center">
                     <CheckCircleIcon className="h-20 w-20 text-yellow-500 bg-yellow-100 rounded-full p-2 border-4 border-white shadow-lg" />
                  </div>
                  <h3 className="text-2xl font-bold text-gray-900 mb-2">Pendaftaran Berhasil Dikirim!</h3>
                  <div className="bg-gray-50 rounded-lg p-4 border border-gray-200 mt-6 inline-block w-full max-w-sm">
                     <div className="flex justify-between items-center mb-2">
                        <span className="text-sm font-semibold text-gray-500">Status Pendaftaran:</span>
                        <span className="bg-yellow-200 text-yellow-800 text-xs px-2 py-1 rounded font-bold uppercase track-wide">Menunggu Verifikasi Admin</span>
                     </div>
                     <p className="text-xs text-gray-600 text-left">
                        Tim admin KANGMAS akan mengecek KTP dan profil Anda dalam waktu 1x24 jam. Kami akan mengirimkan notifikasi via WhatsApp/Email setelah akun disetujui <b>(Approved)</b> atau ditolak <b>(Rejected)</b>.
                     </p>
                  </div>

                  <button type="button" onClick={() => navigate('/')} className="mt-8 w-full block text-center font-bold text-primary hover:text-primary-hover underline">
                     Kembali ke Beranda
                  </button>
               </div>
            )}

            {/* Navigation Buttons */}
            {step < 5 && (
              <div className="mt-8 flex gap-3 pt-5 border-t border-gray-200">
                {step > 1 && (
                   <button type="button" onClick={prevStep} className="w-1/3 bg-white border border-gray-300 text-gray-700 py-2 px-4 rounded font-bold hover:bg-gray-50 transition">
                     Kembali
                   </button>
                )}
                
                {step < 4 ? (
                   <button type="submit" className="flex-1 bg-dark text-white py-2 px-4 rounded font-bold hover:bg-black transition">
                     Lanjut
                   </button>
                ) : (
                   <button type="submit" disabled={loading} className={`flex-1 flex justify-center items-center py-2 px-4 rounded font-bold transition text-gray-900 ${loading ? 'bg-yellow-200 cursor-wait' : 'bg-primary hover:bg-primary-hover'}`}>
                     {loading ? 'Submitting...' : 'Ajukan Pendaftaran'}
                   </button>
                )}
              </div>
            )}

          </form>
        </div>
      </div>
    </div>
  );
}
