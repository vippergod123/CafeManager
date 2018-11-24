
using KTPM_ProjectFinal.DAO;
using KTPM_ProjectFinal.DTO;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace KTPM_ProjectFinal
{
    public partial class fLogin : Form
    {
        public fLogin()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void btnLogin_Click(object sender, EventArgs e)
        {
            string userName = txtbUserName.Text;
            string password = txtbPassword.Text;
            if (CheckLogin(userName,password)) 
            {
                Account loginAccount = AccountDAO.Instance.GetAccountByUserName(userName);

                fTableManager f = new fTableManager( loginAccount);
                this.Hide();
                f.ShowDialog();
                this.Show();
            }
            else 
            {
                MessageBox.Show("Sai username hoặc password!","Thông báo",MessageBoxButtons.OK);
                txtbPassword.Text = null;
            }

            
        }

        bool CheckLogin(string userName, string password)
        {
            return AccountDAO.Instance.Login(userName,password);
        }
        
        private void btnExit_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void fLogin_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (MessageBox.Show("Bạn có thực sự muốn thoát chương trình?","Thông báo",MessageBoxButtons.OKCancel) != System.Windows.Forms.DialogResult.OK) {
                e.Cancel = true;
            }
        }
    }
}
