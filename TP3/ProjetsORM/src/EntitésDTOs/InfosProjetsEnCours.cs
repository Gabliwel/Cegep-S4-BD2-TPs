
using System;

namespace ProjetsORM.EntiteDTOs
{
    public class InfosProjetsEnCours
    {
        public string NomClient;
        public string NomProjet;
        public decimal? Budget;
        public string Gestionnaire;
        public string ContactClient;

        public static bool operator ==(InfosProjetsEnCours statsA, InfosProjetsEnCours statB)
        {
            return statsA.NomClient == statB.NomClient
                && statsA.NomProjet == statB.NomProjet
                && statsA.Budget == statB.Budget
                && statsA.Gestionnaire == statB.Gestionnaire
                && statsA.ContactClient == statB.ContactClient;
        }

        public static bool operator !=(InfosProjetsEnCours statsA, InfosProjetsEnCours statB)
        {
            return !(statsA == statB);
        }
        public override bool Equals(object o)
        {
            InfosProjetsEnCours statsEtud = (InfosProjetsEnCours)o;
            return this == statsEtud;
        }

        public override int GetHashCode()
        {
            return HashCode.Combine(NomClient, NomProjet, Budget, Gestionnaire, ContactClient);
        }
    }
}
