
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;


namespace ProjetsORM.Entites
{
    [Table("CLIENT")]
    public class Client
    {
        #region Propriétés
        #endregion Propriétés
        
        public string NomClient { get; set; }

        public short NoEnregistrement { get; set; }

        public string Rue { get; set; }

        public string Ville { get; set; }

        public string CodePostal { get; set; }

        public decimal? Telephone { get; set; }

        #region Clés étrangères
        #endregion Clés étrangères

        #region Propriétés de navigation 
        #endregion Propriétés de navigation 

        public virtual ICollection<Projet> Projets { get; set; }


        #region Constructeur
        #endregion Constructeur

        public Client()
        {
            Projets = new List<Projet>();
        }

    }
}