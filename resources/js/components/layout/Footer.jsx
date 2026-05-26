import { EnvelopeIcon, PhoneIcon, MapPinIcon, WrenchScrewdriverIcon } from '@heroicons/react/24/outline';

export default function Footer() {
  return (
    <footer id="call-center" className="w-full text-white font-sans">

      <div className="bg-[#6b7280] py-12">
        <div className="kangmas-container">
          <div className="flex flex-col md:flex-row justify-between pb-8 border-b border-gray-500 mb-8 border-dashed">
            {/* Logo */}
            <div className="flex items-center gap-2 mb-6 md:mb-0">
              <WrenchScrewdriverIcon className="h-8 w-8 text-primary" />
              <span className="text-3xl font-bold tracking-tight text-white">KANGMAS</span>
            </div>
            
            {/* Contact Grid */}
            <div className="flex flex-wrap gap-8">
              <div className="flex items-center gap-3">
                <div className="bg-primary p-2 rounded-full">
                  <EnvelopeIcon className="h-5 w-5 text-gray-900" />
                </div>
                <div>
                  <p className="text-xs text-gray-200">Email Kami</p>
                  <p className="text-sm font-semibold text-white">tukangcallcenter@gmail.com</p>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <div className="bg-primary p-2 rounded-full">
                  <PhoneIcon className="h-5 w-5 text-gray-900" />
                </div>
                <div>
                  <p className="text-xs text-gray-200">Kontak Kami</p>
                  <p className="text-sm font-semibold text-white">+62 813-9266-3985</p>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <div className="bg-primary p-2 rounded-full">
                  <MapPinIcon className="h-5 w-5 text-gray-900" />
                </div>
                <div>
                  <p className="text-xs text-gray-200">Lokasi</p>
                  <p className="text-sm font-semibold text-white">Bandung, Indonesia</p>
                </div>
              </div>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div>
              <h3 className="font-semibold text-white mb-4">Jelajahi</h3>
              <ul className="space-y-2 text-sm text-gray-200">
                <li><a href="#" className="hover:text-primary transition-colors">Tentang Kami</a></li>
                <li><a href="#" className="hover:text-primary transition-colors">FAQ</a></li>
              </ul>
            </div>

            <div>
              <h3 className="font-semibold text-white mb-4">Link Instan</h3>
              <ul className="space-y-2 text-sm text-gray-200">
                <li><a href="#" className="hover:text-primary transition-colors">Customer Service</a></li>
                <li><a href="#" className="hover:text-primary transition-colors">Hubungi Kami</a></li>
              </ul>
            </div>

            <div>
              <h3 className="font-semibold text-white mb-4">Halaman Utilitas</h3>
              <ul className="space-y-2 text-sm text-gray-200">
                <li><a href="#" className="hover:text-primary transition-colors">Perizinan</a></li>
                <li><a href="#" className="hover:text-primary transition-colors">Kebijakan & Privasi</a></li>
                <li><a href="#" className="hover:text-primary transition-colors">404 Page</a></li>
              </ul>
            </div>
          </div>
        </div>
      </div>

      <div className="bg-[#4b5563] py-4 text-center text-xs text-gray-300">
        <p>Copyright © KANGMAS | Designed by KANGMAS Design Team</p>
      </div>
    </footer>
  );
}
