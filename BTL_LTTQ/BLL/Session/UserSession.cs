using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BTL_LTTQ.BLL.Session
{
    public static class UserSession
    {
        // Thông tin tài khoản đang đăng nhập
        public static string MaTK { get; set; } // Mã tài khoản
        public static string TenDangNhap { get; set; }
        public static string LoaiTaiKhoan { get; set; }
        public static string MaGV { get; set; } // Mã giảng viên (nếu có)
        public static DateTime LoginTime { get; set; }

        // Kiểm tra trạng thái đăng nhập
        public static bool IsLoggedIn => !string.IsNullOrEmpty(TenDangNhap);

        // Đăng nhập - Lưu thông tin session
        public static void SetUserSession(string maTK, string tenDangNhap, string loaiTaiKhoan, string maGV = null)
        {
            MaTK = maTK;
            TenDangNhap = tenDangNhap;
            LoaiTaiKhoan = loaiTaiKhoan;
            MaGV = maGV;
            LoginTime = DateTime.Now;
        }

        // Đăng xuất - Xóa thông tin session
        public static void ClearSession()
        {
            MaTK = null;
            TenDangNhap = null;
            LoaiTaiKhoan = null;
            MaGV = null;
            LoginTime = DateTime.MinValue;
        }

        // Kiểm tra quyền admin
        public static bool IsAdmin()
        {
            return LoaiTaiKhoan == "Admin";
        }

        // Kiểm tra quyền giảng viên
        public static bool IsGiangVien()
        {
            return LoaiTaiKhoan == "Giảng viên";
        }

        // Lấy thông tin hiển thị
        public static string GetDisplayInfo()
        {
            if (IsLoggedIn)
                return $"Xin chào: {TenDangNhap} ({LoaiTaiKhoan})";
            return "Chưa đăng nhập";
        }

        // Lấy thời gian đăng nhập
        public static string GetLoginTimeInfo()
        {
            if (IsLoggedIn)
                return $"Đăng nhập lúc: {LoginTime:dd/MM/yyyy HH:mm:ss}";
            return "";
        }

        // Kiểm tra session có hết hạn không (ví dụ: 8 tiếng)
        public static bool IsSessionExpired(int hoursLimit = 8)
        {
            if (!IsLoggedIn) return true;
            
            TimeSpan timeDifference = DateTime.Now - LoginTime;
            return timeDifference.TotalHours > hoursLimit;
        }
    }
}
