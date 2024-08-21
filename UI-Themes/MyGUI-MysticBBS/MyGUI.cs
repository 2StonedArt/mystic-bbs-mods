using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Windows.Forms;
using System.Timers;


namespace MyGUI
{



    public partial class MyGUI : Form
    {
        public MyGUI()
        {
            InitializeComponent();
            

        }


        // Variables
        public string misver;
        public string version = " 1.001";
        public string oldpath = "NOT SET";
        public string rootpath = "NOT SET";
        public string resultsInt;
        public string workDir = "Not Set";
        int mysloc;
        public string actualPath = "Not Set";
        int dircount = 0;
        public int sp;
        public string sDircount;
        public string appName = @"\mystic.exe";
        public string p;
        public bool poll;
        public bool flag;
        public bool flagMis;
        public bool sd = false;
        public bool misRun;
        public bool misByMyGUI;
        public string logsPath = "logs";
        public string themesPath = "themes";
        public string mytheme = "pptheme";
        public string docsPath = "docs";
        public string _ChosenFile = "";
        public string[] listDirs = new string[4] { "logs", "themes", "docs", "mystic" };
        public string[] fileExts = new string[3] { ".txt", ".asc", ".log" };
        public string[] CBNets = new string[] { "forced" };
        public string cbSelecteditem = "forced";
        public string procinput = "";
        public int numFiles = 0;
        public string searchPat = "*";
        public int waittimer = 11;
        public int resetTime = 11;
        public string currentDirectory = Environment.CurrentDirectory;
        public string nl = "\n";
        public bool esc;
        public bool missword;
        public int erasel = 0;
        public int stpos = 0;
        public int charcount = 0;
        public string addword = "";
        public string delword = "";
        public string spaces = "";
        public string newline = "";
        public string workPath = "";
        public string choose = "Choose an Option";
        public string thisline = "";
        public string selectedLine = "";
        public string item = "";
        public string logs = "logs";
        public string sema = "semaphore";
        public string themes = "themes";
        public string addchar = "";
        public int numlines = 0;
        public String Ansii { get; set; }
        public String semaFP = ""; //File Path
        public String semaFN = ""; //File Name
        public string semaAT = ""; //Attributes
        public string semaEV = "";
        public string semaON = ""; //Old Name before re name
        public string selectedDir = "";
        public string chosenFile = @"\MyGUI.asc";
        public string root = "";
        public static int secondsCount = 0;
        

        public void Semaphore()
        {
            string watchedFolder = actualPath + sema;
            FileSystemWatcher fsw = new FileSystemWatcher(watchedFolder);
            bbs_Event_semaphore.Text = watchedFolder;
            fsw.IncludeSubdirectories = true;
            fsw.NotifyFilter = NotifyFilters.FileName | NotifyFilters.LastWrite |
                NotifyFilters.Attributes | NotifyFilters.CreationTime;
            fsw.Changed += fsw_Changed;
            fsw.Renamed += fsw_Renamed;
            fsw.Created += fsw_Created;
            fsw.Deleted += fsw_Deleted;
            fsw.EnableRaisingEvents = true;
        }
        private void fsw_Deleted(object sender, FileSystemEventArgs e)
        {
            //throw new NotImplementedException();
            //semaFP = e.FullPath;
            semaFN = e.Name;
            semaAT = e.ChangeType.ToString();
            semaEV = e.GetType().Name;

            bbs_Event_semaphore.Text = semaFN + " " + semaAT + " " + semaEV;
            
        }

        private void fsw_Created(object sender, FileSystemEventArgs e)
        {
            //throw new NotImplementedException();
            //semaFP = e.FullPath;
            semaFN = e.Name;
            semaAT = e.ChangeType.ToString();
            //semaEV = e.GetType().Name;

            bbs_Event_semaphore.Text = semaFN + " " + semaAT;

        }

        private void fsw_Changed(object sender, FileSystemEventArgs e)
        {
            //throw new NotImplementedException();
            //semaFP = e.FullPath;
            semaFN = e.Name;
            semaAT = e.ChangeType.ToString();
            semaEV = e.GetType().Name;
            notifyIcon.BalloonTipTitle = "BBS Event";
            notifyIcon.BalloonTipText = semaFN;
            notifyIcon.ShowBalloonTip(100);
            bbs_Event_semaphore.Text = semaFN + " " + semaAT;
            
        }
        private void fsw_Renamed(object sender, RenamedEventArgs e)
        {
            //throw new NotImplementedException();
            //semaFP = e.FullPath;
            semaFN = e.Name;
            semaAT = e.ChangeType.ToString();
            semaON = e.OldName;

            bbs_Event_semaphore.Text = ">" + semaFN + " " + semaAT + " " + semaON;

        }

        public void Update_dirList()
        {
            WorkingDir.Text = "Dir. " + actualPath;
            tbmysticPath.Text = actualPath;
            lbFileList.Items.Clear();
            dircount = 0;
            foreach (string dirs in listDirs)
            {


            }
            string[] dirlist = Directory.GetDirectories(actualPath, searchPat, SearchOption.TopDirectoryOnly);



            foreach (string dir in dirlist)
            {
                dircount = dircount + 1;
                sDircount = dircount.ToString();
                lbl_TotDirs.Text = sDircount;
                lbFileList.Items.Add(dir);

            }
            //item = "logs";

            if (!flagMis)
            {
                lbFileList.Items.Clear();
                lbFileList.Text = "Error";
            }
            workPath = "";

        }


        public void Btn_setGreen()
        {
            btn_op_logs.BackColor = Color.Green;
            btn_Textedit.BackColor = Color.Green;
            btn_op_themes.BackColor = Color.Green;
            btn_op_Docs.BackColor = Color.Green;
            btn_config.BackColor = Color.Green;
            btn_Ansiedit.BackColor = Color.Green;
            btn_misPoll.BackColor = Color.Green;
            btn_missta.Enabled = true;  // local login btn
            btn_missta.BackColor = Color.Green;
            btn_config.Enabled = true;  // cfg btn
            btn_config.BackColor = Color.Green;
            btn_nSpy.Enabled = true;    // Nodespy btn
            btn_nSpy.BackColor = Color.Green;
            tbmysticPath.Text = actualPath;
            button1.BackColor = Color.Green;
            lbl_misyn.BackColor = Color.Green;

        }
        public void Chk_Startup()
        {
            bool result = File.Exists(currentDirectory + appName);
            if (result)
            {
                button1.Text = "BBS Loc..";
                button1.Enabled = false;
                button1.Cursor = Cursors.WaitCursor;
                rtb_ansi.AppendText("Mystic Found at\n");
               
                lbl_bbsVersion.Text = misver;
                flagMis = true;
                rootpath = currentDirectory + appName;
                root = currentDirectory;
                rtb_ansi.ForeColor = Color.YellowGreen;
                rtb_ansi.AppendText(rootpath + "\n");
                rtb_ansi.AppendText("Directory of BBS set to \n");
                locatemystic();
                rtb_ansi.AppendText(actualPath);
                lblistFiles.Enabled = true;
                lblistFiles.Cursor = Cursors.Hand;
                display_bbs_open_screen();
                readmisVersion();
                Btn_setGreen();
                //tbmysticPath.Clear();
                tbmysticPath.Text = actualPath;
                tbmysticPath.ForeColor = Color.Black;
                Tytle.BackColor = Color.Green;
                //Get_BBS_Vn();
                loadAnsiiCodes();
                Semaphore();
                Update_dirList();
                lblistFiles.Enabled = false;

            }
            else
            {
                rtb_ansi.ForeColor = Color.Red;
                rtb_ansi.AppendText("\n\n\n******\n NOT FOUND\n******\n MyGUI MUST be installed into the same Directory as mystic.exe\nMystic BBS");
                lbl_misyn.BackColor = Color.Red;
                tb_OutPut.Text = " MyGUI Install ERROR...";
                tbmysticPath.Text = actualPath;
                Tytle.BackColor = Color.Red;

                lbFileList.Enabled = false;
                lblistFiles.Enabled = false;
                MessageBox.Show("MyGUI is located at\n" +
                       currentDirectory + "\n" +
                       "Mystic NOT FOUND in this DIR\n" +
                       "\n\nMyGUI must be in the same DIR as mystic.exe,\n\n\nPlease Move MyGUI to\n" +
                       "the same Directory as mystic.exe" +
                       "\nAnd RE-START MyGUI FROM THAT LOCATION",
                       "MyGUI Install ERROR...", MessageBoxButtons.OK);
            }
        }
        public void button1_Click(object sender, EventArgs e)
        {
            button1.BackColor = Color.Red;
            oldpath = rootpath;
            //lbl_misyn.Text = "OFF";
            misrun();
            OpenFileDialog ofd = new OpenFileDialog();
            ofd.Title = "Locate Mystic in the Root install Dir to change from :- " + oldpath;
            ofd.Filter = "Mystic BBS.exe|mystic.exe";
            if (ofd.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                Btn_setGreen();
                rootpath = ofd.FileName;
                if (!flagMis) // mis not in this dir
                {
                    locatemystic();
                    MessageBox.Show("MyGUI is located at\n" +
                        currentDirectory + "\n" +
                        "Mystic NOT FOUND\n" +
                        "\n\nMyGUI must be in the same DIR as mystic.exe,\n\n\nPlease Move MyGUI to\n" +
                        actualPath +
                        "\nAnd RE-START MyGUI FROM THAT LOCATION",
                        "MyGUI Install ERROR...", MessageBoxButtons.OK);
                    sd = true;

                    // timer.Start();     REMOVE the//


                }
                Semaphore();
                Update_dirList();
                //Get_BBS_Vn();

                display_bbs_open_screen();
                ofd.Dispose();

            }

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            button1.Text = "BBS Dir";
            //lbFileList.Items.Clear();
            //lbFileList.Items.Add("Loading");
            lblistFiles.Items.Clear();
            //lblistFiles.Items.Add("Select a Directory");
        }

        public void locatemystic()
        {
            // Find the word mystic in DIR path
            mysloc = rootpath.LastIndexOf("mystic.exe");
            int strlen = rootpath.Length;
            actualPath = rootpath.Substring(0, strlen - 10); // get DIR path only
            root = actualPath;
            flagMis = true;

        }

        public void misrun()
        {
            //misRun = false;
            int count = 0;
            flag = false;
            appName = "mis";
            Process[] ProcessList = Process.GetProcesses();
            foreach (Process p in ProcessList)
            {
                if (p.ProcessName.Contains(appName))
                {

                    // mis found in running apps
                    // lbl_misyn.Text = "LIVE";
                    count++;
                    lbl_RunningProgs.Text = "Running Progs " + count;
                    misRun = true;
                    lbl_misyn.BackColor = Color.Green;
                    btn_misstart.Enabled = false;
                    btn_missto.Enabled = true;  // mis btn
                    btn_misstart.BackColor = Color.Green;
                    btn_misPoll.Enabled = true;
                    btn_misPoll.BackColor = Color.Green;
                    tb_netPoll.Enabled = true;
                    lbl_message.Text = "mis SERVER RUNNUNG";
                    lbl_message.BackColor = Color.Green;
                    lbl_mis.Visible = false;
                    lbl_mis2.ForeColor = Color.Red;
                    lbl_mis2.Visible = true;
                    tbmysticPath.Text = actualPath;
                    flag = true;
                    if (flagMis)
                    {
                        lbl_misyn.BackColor = Color.Green;
                        if (misRun)
                        {
                            tb_OutPut.Text = "mis SERVER RUNNING";
                        }
                    }
                }
                else if (!flag)
                {
                    count = count + 1;
                    //MessageBox.Show("mis NOT Found");
                    lbl_RunningProgs.Text = "Running Progs " + count;
                    lbl_message.Text = "*** mis SERVER is NOT running *** ";
                    lbl_message.BackColor = Color.Red;
                    lbl_mis.Visible = true;
                    lbl_mis.Text = "< SRV";
                    lbl_mis.ForeColor = Color.Yellow;
                    lbl_mis2.Visible = false;
                    btn_misstart.Enabled = true;

                    btn_misstart.BackColor = Color.Red;
                    btn_missto.Enabled = false;
                    //btn_misPoll.Enabled = false;
                    //btn_misPoll.BackColor = Color.Red;
                    tb_netPoll.Enabled = false;
                    if (flagMis)
                    {
                        lbl_misyn.BackColor = Color.Goldenrod;
                        if (!misRun)
                        {
                            tb_OutPut.Text = "mis can be started with SRV Start";
                        }
                    }

                }

                if (!flagMis)
                {
                    btn_misstart.Enabled = false;
                }
            }
        }

        private void btn_missta_Click(object sender, EventArgs e)
        {
            Thread threadmyst = new Thread(runmystic);
            threadmyst.Start();
            lbl_message.Text = "Mystic Local LogIn";

        }

        private void btn_missto_Click(object sender, EventArgs e)
        {
            if (misByMyGUI)
            {
                // Stop mis server
                //waittimer = resetTime;
                Process stopmis = new Process();
                stopmis.StartInfo.FileName = root + "mis";
                stopmis.StartInfo.UseShellExecute = false;
                stopmis.StartInfo.Arguments = "shutdown";
                stopmis.StartInfo.RedirectStandardOutput = true;

                stopmis.Start();
              
                //rtb_ansi.Clear();
                string procout = stopmis.StandardOutput.ReadToEnd();

                misRun = false;
                misrun();
                //Update_dirList();
                lbl_misyn.BackColor = Color.Goldenrod;
                misByMyGUI = false;
                tb_OutPut.Text = procout;
                //rtb_ansi.AppendText(procout);
            }
            else
            {
                lbl_message.Text = "mis SERVER Stop Detected";
                tb_OutPut.Text = "About to STOP mis";
                // Stop mis server
                Process stopmis = new Process();
                stopmis.StartInfo.FileName = root + "mis";
                stopmis.StartInfo.UseShellExecute = false;
                stopmis.StartInfo.Arguments = "shutdown";
                stopmis.StartInfo.RedirectStandardOutput = true;

                stopmis.Start();
                rtb_ansi.Clear();
                rtb_ansi.AppendText(stopmis.StandardOutput.ReadToEnd());
                tb_OutPut.Text = stopmis.StandardOutput.ReadToEnd();
                //timer.Interval = 1000;
                
                misRun = false;
                misrun();
                //Update_dirList();
                lbl_misyn.BackColor = Color.Goldenrod;
                misByMyGUI = false;
            }
        }

        public void runmystic()
        {
            // Start mystic Local LogIn

            Process startmis = new Process();
            startmis.StartInfo.FileName = root + "mystic";
            startmis.StartInfo.UseShellExecute = false;
            startmis.StartInfo.Arguments = "-l";
            startmis.Start();


        }

        private void MyGUI_Load(object sender, EventArgs e)
        {
            lbl_version.Text = "Version" + version;
            tb_OutPut.Text = " ***  INITIALIZING  ***";
            rtb_ansi.AppendText("Working Directory is \n" + currentDirectory + "\n");
            rtb_ansi.AppendText("Checking if MyGUI is installed into the BBS (Mystic) Directory \n");
            rtb_ansi.AppendText("Looking for mystic.exe\n");
            rtb_ansi.AppendText(currentDirectory + appName + "\n");
            
            Chk_Startup();
            misrun();

            startNetRout();
            readNetList();
            cbAddItems();
            int cbnumitems = comboBoxNets.Items.Count;
            //comboBoxNets.Items.RemoveAt(cbnumitems);

            notifyIcon.ShowBalloonTip(100);



        }
        private void loadAnsiiCodes()
        {
            List<AnsiiCode> lstansiiCodes = new List<AnsiiCode>();
            for (int i = 0; i <= 255; i++)
            {
                lstansiiCodes.Add(new AnsiiCode());
                lstansiiCodes[i].Ansii = i.ToString();
            }
            //rtb_ansi.Clear();
            foreach (AnsiiCode code in lstansiiCodes)
            {
                // rtb_ansi.AppendText(code.GetAnsiiCode());
            }
        }


        private void lbl_version_Click(object sender, EventArgs e)
        {
            lbl_version.Text = "MyGUI V" + version;
        }

        private void btn_config_Click(object sender, EventArgs e)
        {
            Thread threadcfg = new Thread(runcfg);
            threadcfg.Start();
            lbl_message.Text = "Mystic Config";
        }
        public void runcfg()
        {

            Process startcfg = new Process();
            startcfg.StartInfo.FileName = root + "mystic";
            startcfg.StartInfo.UseShellExecute = false;
            startcfg.StartInfo.Arguments = "-cfg";
            startcfg.Start();


        }

        private void button2_Click(object sender, EventArgs e)
        {
            Thread threadnspy = new Thread(runnsy);
            threadnspy.Start();
            lbl_message.Text = "Node Spy Started";
        }
        public void runnsy()
        {

            Process startnsp = new Process();
            startnsp.StartInfo.FileName = root + "nodespy";
            startnsp.StartInfo.UseShellExecute = false;
            startnsp.StartInfo.Arguments = "";

            startnsp.Start();

        }

        private void btn_exit_Click(object sender, EventArgs e)
        {

            this.Close();
        }

        private void display_bbs_open_screen()
        {



            string myFilepath = actualPath + chosenFile;
            _ChosenFile = myFilepath;

            List<string> lines = new List<string>();
            lines = File.ReadAllLines(myFilepath, Encoding.UTF7).ToList();


            rtb_ansi.Clear();

            numlines = 0;
            foreach (string line in lines)

            {

                numlines++;
                thisline = line;
                ansi_colour();

            }
            lbl_message.Text = "File " + chosenFile + " displayed";
        }

        private void btn_misstart_Click(object sender, EventArgs e)
        {
            Thread threadmisrun = new Thread(startmisserver);

            lbl_message.Text = "Attempting to Start Mis Server";
            threadmisrun.Start();
            tb_OutPut.Text = "Start mis request sent ";
            misByMyGUI = true;
            lbl_misyn.BackColor = Color.Green;

        }

        public void startmisserver()
        {
            // START mis server
            Process startmis = new Process();
            startmis.StartInfo.FileName = root + "mis";
            startmis.StartInfo.UseShellExecute = false;
            startmis.StartInfo.Arguments = "server";
            startmis.StartInfo.RedirectStandardOutput = false;

            startmis.Start();
            misRun = true;
            misrun();
            //lbFileList.Items.Add(root);
        }

        private void btn_misPoll_Click(object sender, EventArgs e)
        {
            poll = true;
            //MessageBox.Show("Polling\n" +comboBoxNets.Text);
            Thread threadmisPoll = new Thread(startmisPoll);
            cbSelecteditem = comboBoxNets.Text;
            lbl_message.Text = "Attempting to Poll NET " + comboBoxNets.Text;
            threadmisPoll.Start();
            tb_OutPut.Text = "mis Poll request sent ";
            //misByMyGUI = true;

        }

        public void startmisPoll()
        {
            try
            {
                // START mis server
                Process startmis = new Process();
                startmis.StartInfo.FileName = root + "mis";
                startmis.StartInfo.UseShellExecute = false;
                startmis.StartInfo.Arguments = "poll " + cbSelecteditem;
                startmis.StartInfo.RedirectStandardOutput = false;

                startmis.Start();

                //misrun();

            }
            catch (Exception ex)
            {
                MessageBox.Show("Poll Error\n" + ex + "\n Check logs for more");

            }


        }

       

        private void rtb_ansi_TextChanged(object sender, EventArgs e)
        {

        }

        private void btn_op_logs_Click(object sender, EventArgs e)
        {
            btn_op_logs.Enabled = false;
            btn_op_themes.Enabled = true;
            btn_op_Docs.Enabled = true;
            actualPath = root;
            workPath = actualPath + logsPath;
            actualPath = workPath;
            WorkingDir.Text = workPath;
            lblistFiles.Items.Clear();
            var theseFiles = Directory.GetFiles(actualPath, "*", SearchOption.TopDirectoryOnly);
            var numFiles = 0;
            lbl_NumFiles.Text = numFiles.ToString();
            foreach (string file in theseFiles)
            {
                numFiles++;
                lblistFiles.Items.Add(Path.GetFileName(file));
                lbl_NumFiles.Text = numFiles.ToString();
            }
            if (numFiles > 0)
            {
                lblistFiles.Enabled = true;
            }
            else
            {
                lbl_NumFiles.Text = numFiles.ToString();
                lblistFiles.Enabled = false;
                lbl_TotDirs.Text = numFiles.ToString();
            }
            lbFileList.Items.Clear();
            lbFileList.Items.Add(root); //put rootpath into list
            lbl_TotDirs.Text = "0";

        }

        public void ansi_colour()
        {
            stripCodes();
            rtb_ansi.AppendText("\n");
            rtb_ansi.AppendText(newline);

        }

        private void stripCodes()
        {
            stripAnsiCodes();

        }

        public void stripAnsiCodes()
        {

            bool oktoadd = true;
            char C = 'C';
            char m = 'm';
            char H = 'H';
            char J = 'J';
            char sc = ';';
            char pipe = '|';
            char previous = ' ';
            char brac = '[';
            bool pipey = false;
            delword = "";
            missword = false;
            esc = false;
            int length = thisline.Length;
            newline = "";
            for (int i = 0; i < length; i++)

            {

                char charector = thisline.ElementAt(i);

                oktoadd = true;
                if (charector == 27)
                {
                    missword = true;
                    esc = true;
                    oktoadd = false;

                }

                if (esc)
                {
                    if (charector == pipe)
                    {
                        pipey = true;
                    }

                    if (charector == m)
                    {
                        lbl_AnsiiCodeNo.Text = delword;
                        esc = false;
                        oktoadd = false;
                        delword = "";
                    }
                    else
                    {
                        missword = true;
                    }
                    if (charector == C)
                    {

                        if (previous != brac)
                        {
                            esc = false;
                            oktoadd = false;
                            if (sp > 0)
                            {
                                for (int s = 0; s < sp; s++)
                                {
                                    spaces = spaces + " "; //add sp spaces
                                }
                            }
                        }

                    }
                    else
                    {
                        missword = true;
                    }
                    if (charector == J)
                    {
                        delword = "";
                        esc = false;
                        oktoadd = false;


                    }
                    else
                    {
                        missword = true;
                    }
                    if (charector == sc)
                    {
                        delword = "";
                        esc = false;
                        oktoadd = false;


                    }
                    else
                    {
                        missword = true;
                    }
                    if (charector == H)
                    {
                        delword = "";
                        esc = false;
                        oktoadd = false;

                    }
                    else
                    {
                        missword = true;
                    }
                }

                if (missword)
                {
                    if (charector == pipe)
                    {
                        pipey = true;
                    }
                    if (charector > 47)
                    {
                        if (charector < 58)
                        {
                            delword = delword + charector.ToString();
                            int spaces = Convert.ToInt32(delword);
                            sp = spaces;
                        }
                    }

                    oktoadd = false;
                    if (charector == m)
                    {
                        esc = false;
                        missword = false;

                    }
                    if (charector == C)
                    {

                        if (previous != brac)
                        {
                            esc = false;
                            missword = false;
                            int spaces = Convert.ToInt32(delword);
                            sp = spaces;
                        }

                    }
                    if (charector == H)
                    {
                        esc = false;
                        missword = false;

                        delword = "";
                    }
                    if (charector == J)
                    {
                        esc = false;
                        missword = false;


                    }
                }
                if (!esc)
                {
                    if (!missword)
                    {
                        if (oktoadd)
                        {
                            addword = charector.ToString();
                            newline = newline + spaces + addword;
                            spaces = "";
                        }

                    }

                }
                previous = charector;

            }
            addword = addword + "\n";

        }

        //private void Get_BBS_Vn()
        //{
        //    StreamReader reader = new StreamReader(actualPath + "mystic.dat");


        //    String bbs_versionLine = reader.ReadLine();
        //    int strlen = bbs_versionLine.Length;

        //    String actualVersion = bbs_versionLine.Substring(1, strlen - 9); // get Version text only

        //    lbl_bbsVersion.Text = actualVersion;
        //    reader.Close();
        //}



        private void bbs_Event_semaphore_Click(object sender, EventArgs e)
        {

        }

        private void lbl_version_MouseHover(object sender, EventArgs e)
        {
            lbl_version.Text = "© Owen Evers 2021";
        }

        private void lbl_version_MouseLeave(object sender, EventArgs e)
        {
            lbl_version.Text = "MyGUI V" + version;
        }

        private void lbFileList_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {


                selectedDir = lbFileList.SelectedItem.ToString();

                if (selectedDir != null)
                {
                    numFiles = 0;
                    WorkingDir.Text = selectedDir;
                    if (selectedDir != root)
                    {
                        actualPath = selectedDir;
                        lblistFiles.Items.Clear();


                        var theseFiles = Directory.GetFiles(selectedDir, "*", SearchOption.TopDirectoryOnly);



                        lbl_NumFiles.Text = numFiles.ToString();

                        Update_dirList();
                        lbFileList.Items.Add(root);
                        foreach (string file in theseFiles)
                        {

                            foreach (string ext in fileExts)
                            {

                                if (ext == Path.GetExtension(file))
                                {
                                    numFiles++;
                                    lblistFiles.Items.Add(Path.GetFileName(file));

                                }
                            }

                            lbl_NumFiles.Text = numFiles.ToString();
                        }
                        if (numFiles == 0)
                        {
                            btn_Ansiedit.Enabled = false;
                            lblistFiles.Enabled = false;
                        }
                        else
                        {
                            btn_Ansiedit.Enabled = false;
                            btn_op_Docs.Enabled = true;
                            btn_op_themes.Enabled = true;
                            btn_op_logs.Enabled = true;
                            lblistFiles.Enabled = true;
                        }
                        workPath = root;

                    }
                    else
                    {
                        btn_Ansiedit.Enabled = false;
                        lbl_NumFiles.Text = "0";
                        actualPath = root;
                        lblistFiles.Enabled = false;
                        lblistFiles.Items.Clear();
                        btn_op_themes.Enabled = true;
                        btn_op_logs.Enabled = true;
                        btn_op_Docs.Enabled = true;
                        Update_dirList();
                    }
                }
                // }
            }
            catch
            {
                sd = false;
                lbl_message.Text = "Select  a Directory";
                
            }



        }

        private void lblistFiles_SelectedIndexChanged(object sender, EventArgs e)
        {

            var watch = System.Diagnostics.Stopwatch.StartNew();

            chosenFile = @"\";
            chosenFile = chosenFile + lblistFiles.SelectedItem.ToString();
            btn_Ansiedit.Enabled = true;
            lbl_Chosenfile.Text = chosenFile;           // _ChosenFile = myFilepath;  full path
            display_bbs_open_screen();
            watch.Stop();
            tb_OutPut.Text = "File Decoded " + chosenFile;
            var elapsedMs = watch.ElapsedMilliseconds;
            lbl_timeTaken.Text = elapsedMs.ToString() + "Ms";

        }

        private static void shutdownMyGUI()
        {


        }

        private void btn_op_themes_Click(object sender, EventArgs e)
        {
            btn_op_logs.Enabled = true;
            btn_op_themes.Enabled = false;
            btn_op_Docs.Enabled = true;
            actualPath = root;
            workPath = actualPath + themesPath;
            actualPath = workPath;
            WorkingDir.Text = workPath;
            lblistFiles.Enabled = false;
            WorkingDir.Text = workPath;
            lblistFiles.Items.Clear();
            Update_dirList();
            pathThemes.Text = dircount.ToString() + " Installed Themes";
            lbFileList.Items.Add(root);
            lbl_NumFiles.Text = "0";
            string[] dirlist = Directory.GetDirectories(actualPath, "*", SearchOption.AllDirectories);
            var numFiles = 0;


            foreach (string dir in dirlist)
            {
                numFiles++;
                // sDircount = dircount.ToString();
                lbl_TotDirs.Text = sDircount;
                lblistFiles.Items.Add(dir);
                lbl_NumFiles.Text = numFiles.ToString();

            }

        }

        private void bbs_Event_Click(object sender, EventArgs e)
        {

        }

        private void fileToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void menuStrip1_ItemClicked(object sender, ToolStripItemClickedEventArgs e)
        {

        }

        private void exitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btn_op_Docs_Click(object sender, EventArgs e)
        {
            btn_op_logs.Enabled = true;
            btn_op_themes.Enabled = true;
            btn_op_Docs.Enabled = false;
            actualPath = root;
            workPath = actualPath + docsPath;
            actualPath = workPath;
            WorkingDir.Text = workPath;
            lblistFiles.Items.Clear();
            var theseFiles = Directory.GetFiles(actualPath, "*", SearchOption.TopDirectoryOnly);
            var numFiles = 0;
            lbl_NumFiles.Text = numFiles.ToString();
            foreach (string file in theseFiles)
            {
                numFiles++;
                lblistFiles.Items.Add(Path.GetFileName(file));
                lbl_NumFiles.Text = numFiles.ToString();
            }
            if (numFiles > 0)
            {
                lblistFiles.Enabled = true;
            }
            else
            {
                lbl_NumFiles.Text = numFiles.ToString();
                lblistFiles.Enabled = false;
                lbl_TotDirs.Text = numFiles.ToString();
            }
            lbFileList.Items.Clear();
            lbFileList.Items.Add(root); //put rootpath into list
            lbl_TotDirs.Text = "0";

        }

        private void bBSConfigToolStripMenuItem_Click(object sender, EventArgs e)
        {
            btn_config_Click(sender, e);
        }

        private void nodeSpyToolStripMenuItem_Click(object sender, EventArgs e)
        {
            button2_Click(sender, e);
        }

        private void localLogInToolStripMenuItem_Click(object sender, EventArgs e)
        {
            btn_missta_Click(sender, e);
        }

        private void sRVStartToolStripMenuItem_Click(object sender, EventArgs e)
        {
            btn_misstart_Click(sender, e);
        }

        private void sRVStopToolStripMenuItem_Click(object sender, EventArgs e)
        {
            btn_missto_Click(sender, e);
        }

        private void aboutToolStripMenuItem_Click(object sender, EventArgs e)
        {
            AboutBox1 aboutBox1 = new AboutBox1();
            aboutBox1.Show();
        }

        private void MyGUIhelpToolStripMenuItem_Click(object sender, EventArgs e)
        {
            //MessageBox.Show(" path " + root);
            Help.ShowHelp(this, root + "MyGUI Help.chm");
        }

        private void lbl_NumFiles_Click(object sender, EventArgs e)
        {

        }

        private void lbl_Info_Click(object sender, EventArgs e)
        {

        }

        private void btn_Ansiedit_Click(object sender, EventArgs e)
        {
            Thread threadAnsi = new Thread(runAnsiEdit);
            threadAnsi.Start();
            lbl_message.Text = "Ansi Editor Started for " + chosenFile;
        }
        public void runAnsiEdit()
        {           // Start Ansi Edit
            try
            {
                Process startAnsiEdit = new Process();
                startAnsiEdit.StartInfo.FileName = root + "mystic";
                startAnsiEdit.StartInfo.UseShellExecute = false;
                startAnsiEdit.StartInfo.Arguments = "-ansi " + _ChosenFile;
                startAnsiEdit.Start();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Failed to open file\n" + ex);
            }

        }

        private void readNetRout(object sender, EventArgs e)
        {
            Thread threadNetRout = new Thread(startNetRout);

            lbl_message.Text = "Getting Net Routs";
            threadNetRout.Start();
            tb_OutPut.Text = "Net Routs Obtained ";
            misByMyGUI = true;
        }

        public void startNetRout()
        {
            try
            {
                // Domis poll forced
                Process startNetRout = new Process();
                startNetRout.StartInfo.FileName = root + "mis";
                startNetRout.StartInfo.UseShellExecute = false;
                startNetRout.StartInfo.Arguments = "poll route";
                startNetRout.StartInfo.RedirectStandardOutput = true;
                startNetRout.StartInfo.CreateNoWindow = true;


                //
                startNetRout.Start();
                procinput = startNetRout.StandardOutput.ReadToEnd();
                rtb_ansi.AppendText(procinput);
                int tohere = procinput.Length;
                int fromhere = procinput.IndexOf(")");
                String result = procinput.Substring(fromhere + 2);
                result = result.TrimStart();
                tb_NetRouting.Text = result;

                //misRun = true;
                //misrun();
            }
            catch
            {
                MessageBox.Show("Poll Error\n Check Correct Install Directory\n Check logs for more");

            }


        }
        private void readNetList()
        {
            Thread threadNetList = new Thread(startNetList);

            lbl_message.Text = "Net Poll List Assigns";
            threadNetList.Start();
            //tb_OutPut.Text = "Net Rout List Obtained ";
            rtb_ansi.AppendText("Net Rout List Obtained ");
        }

        public void startNetList()
        {
            try
            {
                // Domis poll list
                Process startNetList = new Process();
                startNetList.StartInfo.FileName = root + "mis";
                startNetList.StartInfo.UseShellExecute = false;
                startNetList.StartInfo.Arguments = "poll list";
                startNetList.StartInfo.RedirectStandardOutput = true;
                startNetList.StartInfo.CreateNoWindow = true;


                //
                startNetList.Start();
                procinput = startNetList.StandardOutput.ReadToEnd();
                rtb_ansi.AppendText(procinput);
                var results = procinput.Split('@');
                int frompos;
                int PNnum = 0;
                foreach (string line in results)
                {
                    //rtb_ansi.AppendText(line);
                    int linelength = line.Length;
                    frompos = line.LastIndexOf(" ");
                    string thisnet = line.Substring(frompos + 1);
                    //CBNets.Append(thisnet);
                    comboBoxNets.Items.Add(thisnet);
                    PNnum++;

                    rtb_ansi.AppendText("\n................\n" + thisnet);
                }
                comboBoxNets.Items.RemoveAt(PNnum + 1);
                PNnum = PNnum + 1;
                lbl_PNnum.Text = PNnum.ToString();
                misrun();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Net List Error\n" + ex);

            }


        }

        public void cbAddItems()
        {
            //comboBoxNets.Items.Clear();
            //comboBoxNets.DataSource = CBNets;
        }

        private void comboBoxNets_SelectedIndexChanged(object sender, EventArgs e)
        {
            cbSelecteditem += comboBoxNets.SelectedItem;
        }

        private void toolStripMenuHelp_Click(object sender, EventArgs e)
        {
            Help.ShowHelp(this, root + "MyGUI Help.chm");
        }

        private void toolStripMenuClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void timerMis_Tick(object sender, EventArgs e)
        {
            secondsCount++;
            lbl_DateTime.Text = $"{DateTime.Now}";
            if (secondsCount == 15)
            {
                misrun();
                secondsCount = 0;
            }
        }

        private void readmisVersion()
        {
            Thread threadReadMisVer = new Thread(startMisVer);
            rtb_ansi.AppendText("Looking for Mystic version..." + nl);
            lbl_message.Text = "Getting Version Info";
            threadReadMisVer.Start();
            tb_OutPut.Text = "Version Seek ";
            misByMyGUI = true;
        }

        public void startMisVer()
        {
            try
            {
                // Domis poll forced
                Process startGetVers = new Process();
                startGetVers.StartInfo.FileName = root + "mis";
                startGetVers.StartInfo.UseShellExecute = false;
                startGetVers.StartInfo.Arguments = "ver";
                startGetVers.StartInfo.RedirectStandardOutput = true;
                startGetVers.StartInfo.CreateNoWindow = true;

                startGetVers.Start();
                string proc = startGetVers.StandardOutput.ReadToEnd();

                rtb_ansi.AppendText(proc);
                
                int tohere = proc.Length;
                int fromhere = proc.IndexOf(".");
                String result = proc.Substring(fromhere +7,31);
                misver = proc.Substring(fromhere -2,9);
                lbl_bbsVersion.Text = misver;
                result = result.TrimStart();
                tb_netPoll.Text = result;

                //misRun = tru
                //misrun();
            }
            catch(Exception ex)
            {
                MessageBox.Show("Get Mystic Version Error\n Check Correct Install Directory\n Check logs for more"+nl+ex);

            }


        }
    }

}
