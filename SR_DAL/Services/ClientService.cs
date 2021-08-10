﻿using SR_DAL.Data;
using SR_DAL.Repos;
using SR_DAL.Mappers;
using System.Linq;
using Tools.Connections.Database;


namespace SR_DAL.Services
{
    public class ClientService : IClientRepo
    {
        private readonly Connection _conn;

        public ClientService(Connection conn)
        {
            _conn = conn;
        }

        public Client Get(int id)
        {
            Command cmd = new Command("SELECT [Id], [fname], [lname], [bdate], [email], [ccard], [idcard], [book_count], [is_vip], [is_healthy] FROM [Clients] WHERE Id = @id;", false);
            cmd.AddParameter("id", id);
            return _conn.ExecuteReader(cmd, dr => dr.ToClient()).SingleOrDefault();
        }

        public void Register(Client client)
        {
            Command cmd = new Command("RegisterClient", true);
            cmd.AddParameter("fname", client.fname);
            cmd.AddParameter("lname", client.lname);
            cmd.AddParameter("bdate", client.bdate);
            cmd.AddParameter("pass", client.pass);
            cmd.AddParameter("email", client.email);
            cmd.AddParameter("ccard", client.ccard);
            cmd.AddParameter("idcard", client.idcard);
            cmd.AddParameter("book_count", client.book_count);
            cmd.AddParameter("is_vip", client.is_vip);
            cmd.AddParameter("is_healthy", client.is_healthy);
            _conn.ExecuteNonQuery(cmd);
            client.pass = null;
        }

        public Client Login(string email, string pass)
        {
            Command cmd = new Command("AuthClient", true);
            cmd.AddParameter("Email", email);
            cmd.AddParameter("Passwd", pass);

            return _conn.ExecuteReader(cmd, dr => dr.ToClient()).SingleOrDefault();
        }
    }
}
