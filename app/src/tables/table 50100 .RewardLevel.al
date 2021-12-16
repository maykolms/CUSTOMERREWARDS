table 70100 "Reward Level"
{
    fields
    {
        field(1; Level; Text[20]) { }

        field(2; "Minimum Reward Points"; Integer)
        {
            MinValue = 0;
            NotBlank = true;

            trigger OnValidate();
            var
                tempPoints: Integer;
                RewardLevel: Record "Reward Level";
            begin
                tempPoints := "Minimum Reward Points";
                RewardLevel.SetRange("Minimum Reward Points", tempPoints);
                if RewardLevel.FindFirst then
                    Error('Minimum Reward Points must be unique');
            end;
        }
    }

    keys
    {
        key(PK; Level)
        {//Clustered Establece un valor que indica si la clave también define el índice en clúster de la base 
         //de datos.De forma predeterminada, la clave principal se configura como la clave en clúster.

            Clustered = true;
        }
        key("Minimum Reward Points"; "Minimum Reward Points") { }
    }

    trigger OnInsert();
    begin

        Validate("Minimum Reward Points");//Validar el nuevo valor insertado con las  las propiedades y el codigo 
        //que se han definido para ese campo, en este caso el rango del numero y el codigo de OnValidate()
    end;

    trigger OnModify();
    begin
        Validate("Minimum Reward Points");
    end;
}