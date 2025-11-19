using BTL_LTTQ.GUI;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace BTL_LTTQ
{
    public partial class FormMain : Form
    {
        private formMonHoc formMonHocInstance;
        private formGV formGVInstance;
        private formPhanCongGV formPhanCongGVInstance;
        private formLopTC formLopTCInstance;
        private formDiem formDiemInstance;
        private formSV formSVInstance;

        public FormMain()
        {
            InitializeComponent();
            LoadFormMonHoc();
            
            // Thêm sự kiện click cho các panel
            panelPhanCongGiangVien.Click += PanelPhanCongGiangVien_Click;
            panelMonHoc.Click += PanelMonHoc_Click;
            panelGiangVien.Click += PanelGiangVien_Click;
            paneLopTC.Click += paneLopTC_Click;
            panelDiem.Click += PanelDiem_Click;
            panelSinhVien.Click += panelSinhVien_Click;
        }
        
        private void LoadFormMonHoc()
        {
            try
            {
                formMonHocInstance = new formMonHoc();
                ConfigureAndLoadForm(formMonHocInstance);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi: " + ex.Message);
            }
        }

        private void LoadFormGV()
        {
            try
            {
                formGVInstance = new formGV();
                ConfigureAndLoadForm(formGVInstance);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi: " + ex.Message);
            }
        }

        private void LoadFormPhanCongGV()
        {
            try
            {
                formPhanCongGVInstance = new formPhanCongGV();
                ConfigureAndLoadForm(formPhanCongGVInstance);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi: " + ex.Message);
            }
        }

        private void LoadFormLopTC()
        {
            try
            {
                formLopTCInstance = new formLopTC();
                ConfigureAndLoadForm(formLopTCInstance);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi: " + ex.Message);
            }
        }

        private void LoadFormDiem()
        {
            try
            {
                formDiemInstance = new formDiem();
                ConfigureAndLoadForm(formDiemInstance);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi: " + ex.Message);
            }
        }

        private void LoadFormSV()
        {
            try
            {
                formSVInstance = new formSV();
                ConfigureAndLoadForm(formSVInstance);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi: " + ex.Message);
            }
        }

        private void ConfigureAndLoadForm(Form formInstance)
        {
            formInstance.TopLevel = false;
            formInstance.FormBorderStyle = FormBorderStyle.None;
            formInstance.Dock = DockStyle.Fill;
            
            panelMain.Controls.Clear();
            panelMain.Controls.Add(formInstance);
            formInstance.Show();
        }

        private void PanelPhanCongGiangVien_Click(object sender, EventArgs e)
        {
            LoadFormPhanCongGV();
        }

        private void PanelMonHoc_Click(object sender, EventArgs e)
        {
            LoadFormMonHoc();
        }

        private void PanelGiangVien_Click(object sender, EventArgs e)
        {
            LoadFormGV();
        }

        private void paneLopTC_Click(object sender, EventArgs e)
        {
            LoadFormLopTC();
        }

        private void PanelDiem_Click(object sender, EventArgs e)
        {
            LoadFormDiem();
        }

        private void panelSinhVien_Click(object sender, EventArgs e)
        {
            LoadFormSV();
        }
    }
}