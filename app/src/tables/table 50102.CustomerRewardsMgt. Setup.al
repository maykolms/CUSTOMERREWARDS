table 70102 "Customer Rewards Mgt. Setup"  //Configuracion de la gestion de las recompensas del cliente
{
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }

        field(2; "Customer Rewards Ext. Mgt. Codeunit ID"; Integer)//ID del Codeunit que gestiona o administra
        //la extension Recompensas del cliente.
        {
            TableRelation = "CodeUnit Metadata".ID;//Configura una búsqueda en otra tabla. en este caso la tabla "CodeUnit Metadata"
            //y busca el campo ID
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}