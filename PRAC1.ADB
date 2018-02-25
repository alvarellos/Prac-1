-- PRÁCTICA 1.1. METODOLOGÍA DE LA PROGRAMACIÓN --

-- Diego Díaz Alvarellos

with Ada.Text_IO, Ada.Integer_Text_Io;
use Ada.Text_Io, Ada.Integer_Text_Io;

procedure Prac1 is
--package Enumeration_Boolean is new Ada.Text_IO.Enumeration_IO (Boolean);  

   --*******************************************************--

   -- a) Definición de tipos:

   Tam_Nombre_Maquina : constant :=4;
   Tam_Nombre_Usuario : constant := 6;
   Tam_Max_Texto : constant := 40;

   type Tipo_Fecha is
   record
      Dia : Positive range 1..31;
      Mes : Positive range 1..12;
      Agno : Integer;
   end record;
   type Tipo_Dominio is new String (1..3);
   type Tipo_Nombre_Maquina is new String (1..Tam_Nombre_Maquina);
   type Tipo_Nombre_Usuario is new String (1..Tam_Nombre_Usuario);
   type Tipo_Texto_Mensaje is new String (1..Tam_Max_Texto);
   -------------------------------------------------
   type Tipo_Direccion is
   record
      Nombre : Tipo_Nombre_Usuario;
      Maquina : Tipo_Nombre_Maquina;
      Dominio : Tipo_Dominio;
   end record;
   -------------------------------------------------
   type Tipo_Mensaje is
   record
      Direccion_Correo_Emisor : Tipo_Direccion;
      Direccion_Correo_Receptor : Tipo_Direccion;
      Fecha_Emision_Mensaje : Tipo_Fecha;
      Texto_Del_Mensaje : Tipo_Texto_Mensaje;
   end record;

   type Tipo_Coleccion_Mensajes is array (Positive range <>) of Tipo_Mensaje;


   -----------------------------------------------------------
   -----------------------------------------------------------

   -- b)Implementacion de funciones

   -----------------------------------------------------------
   -----------------------------------------------------------

      -- Funciones auxiliares :
      -----------------------------------------------------------
      function Comparar_Fechas (Fecha : Tipo_Fecha; Fecha_M : Tipo_Mensaje) return Boolean is
      -- PRE: fecha correcta.
      -- POST: "compara las fechas y devuelve verdadero si la fecha del mensaje recibido es anterior 
      --       a una fecha"

      begin
         if Fecha.Agno > Fecha_M.Fecha_Emision_Mensaje.Agno then return True;
         elsif Fecha.Agno < Fecha_M.Fecha_Emision_Mensaje.Agno then return False;
         else
            if Fecha.Mes > Fecha_M.Fecha_Emision_Mensaje.Mes then return True;
            elsif Fecha.Mes < Fecha_M.Fecha_Emision_Mensaje.Mes then return False;
            else
               if Fecha.Dia > Fecha_M.Fecha_Emision_Mensaje.Dia then return True;
               elsif Fecha.Dia < Fecha_M.Fecha_Emision_Mensaje.Dia then return False;
               else return False;
               end if;
            end if;
          end if;
      end Comparar_Fechas;
      -----------------------------------------------------------
      function Comparar_Fechas2 (Fecha : Tipo_Fecha; Fecha_M : Tipo_Mensaje) return Boolean is
      -- PRE: fecha correcta.
      -- POST: "compara las fechas y devuelve verdadero si la fecha del mensaje recibido es anterior 
      --       a una fecha"

      begin
         if Fecha.Agno < Fecha_M.Fecha_Emision_Mensaje.Agno then return True;
         elsif Fecha.Agno > Fecha_M.Fecha_Emision_Mensaje.Agno then return False;
         else
            if Fecha.Mes < Fecha_M.Fecha_Emision_Mensaje.Mes then return True;
            elsif Fecha.Mes > Fecha_M.Fecha_Emision_Mensaje.Mes then return False;
            else
               if Fecha.Dia < Fecha_M.Fecha_Emision_Mensaje.Dia then return True;
               elsif Fecha.Dia > Fecha_M.Fecha_Emision_Mensaje.Dia then return False;
               else return False;
               end if;
            end if;
         end if;
      end Comparar_Fechas2;
      -----------------------------------------------------------
      function Comparar_Propietarios (Nombre_Propietario : Tipo_Nombre_Usuario; Nombre_Propietario_Mensaje : Tipo_Mensaje) return Boolean is
      -- PRE: cierto
      -- POST: "Devuelve cierto si la dirección del propietario coincide con la dirección del receptor que viene en el mensaje"

      begin
         if Nombre_Propietario = Nombre_Propietario_Mensaje.Direccion_Correo_Receptor.Nombre then
          --Nombre_Propietario.Maquina = Nombre_Propietario_Mensaje.Direccion_Correo_Receptor.Maquina and then
          --Nombre_Propietario.Dominio = Nombre_Propietario_Mensaje.Direccion_Correo_Receptor.Dominio then
            return True;
            else return False;
         end if;
      end Comparar_Propietarios;
      -----------------------------------------------------------
      function Comparar_Emisores (Nombre_Emisor : Tipo_Nombre_Usuario; Nombre_Emisor_Mensaje : Tipo_Mensaje) return Boolean is
      -- PRE: cierto
      -- POST: "Devuelve cierto si la dirección del emisor coincide con la dirección del emisor que viene en el mensaje"

      begin
         if Nombre_Emisor = Nombre_Emisor_Mensaje.Direccion_Correo_Emisor.Nombre then
          --Nombre_Emisor.Maquina = Nombre_Emisor_Mensaje.Direccion_Correo_Emisor.Maquina and then
          --Nombre_Emisor.Dominio = Nombre_Emisor_Mensaje.Direccion_Correo_Emisor.Dominio then
            return True;
            else return False;
         end if;
      end Comparar_Emisores;
      -----------------------------------------------------------

   -- Fucines principales :
   -----------------------------------------------------------------
   function Hay_Mensajes (Mensajes : Tipo_Coleccion_Mensajes;
                        Propietario, Emisor : Tipo_Nombre_Usuario;
                        Una_Fecha : Tipo_Fecha) return Boolean is
   -- PRE : cierto
   -- POST : "Devuelve cierto si hay algún mensaje que ha recibido el
   --       usuario Propietario del usuario Emisor antes de Una_Fecha (no se inlcuye)
   --       entre los mensajes de Mensajes."


   begin
      if Mensajes'Length = 0 then return False;
      elsif Comparar_Propietarios (Propietario, Mensajes(Mensajes'First)) and then
            Comparar_Emisores (Emisor, Mensajes(Mensajes'First)) and then
            Comparar_Fechas (Una_Fecha, Mensajes (Mensajes'First)) then
      return True;
      elsif Hay_Mensajes (Mensajes(Mensajes'First+1..Mensajes'Last), Propietario, Emisor, Una_Fecha) then return True;
      else return False;
      end if;
   end Hay_Mensajes;

   -----------------------------------------------------------
   -----------------------------------------------------------
   function Cuantos_Mensajes_Entre (Mensajes : Tipo_Coleccion_Mensajes;
                                  Un_Usuario : Tipo_Nombre_Usuario;
                                  Una_Fecha, Otra_Fecha : Tipo_Fecha) return Integer is
   -- Pre : Una_Fecha <= Otra_Fecha
   -- Pos : "Devuelve el numero de mensajes recibidos por Un_Usuario entre
   --       Una_Fecha y Otra_Fecha que hay en Mensajes."

   Resultado : Integer;

   begin

      if Mensajes'Length = 0 then Resultado := 0;
      elsif Comparar_Fechas2 (Una_Fecha, Mensajes(Mensajes'First)) and then
            Comparar_Propietarios (Un_Usuario, Mensajes(Mensajes'First)) and then
            Comparar_Fechas (Otra_Fecha, Mensajes(Mensajes'First)) then
      Resultado := 1 + Cuantos_Mensajes_Entre (Mensajes(Mensajes'First+1..Mensajes'Last), Un_Usuario, Una_Fecha, Otra_Fecha);
      else Resultado := Cuantos_Mensajes_Entre (Mensajes(Mensajes'First+1..Mensajes'Last), Un_Usuario, Una_Fecha, Otra_Fecha);
      end if;
      return Resultado;

   end Cuantos_Mensajes_Entre;

   --*******************************************************--

   -- CONSTANTES

   Propietario: constant Tipo_Nombre_Usuario := ("Diego ");
   Emisor: constant Tipo_Nombre_Usuario := ("Zapete");
   Una_Fecha : constant Tipo_Fecha := (1, 1, -300);
   Primera_Fecha : constant Tipo_Fecha := (1, 1, 2001);
   Segunda_Fecha: constant Tipo_Fecha := (31, 12, 2001);
   Propietario_Primer_Mensaje : constant Tipo_Direccion := ("Diego ", "mail", "com");
   Emisor_Primer_Mensaje : constant Tipo_Direccion := ("Zapete", "mail", "com");
   Fecha_Primer_Mensaje : constant Tipo_Fecha := (9, 1, 2001);
   Mensajes : constant Tipo_Coleccion_Mensajes := ((Emisor_Primer_Mensaje, Propietario_Primer_Mensaje, Fecha_Primer_Mensaje, "Con el primer rayo de luz despertó Pedro"),
   (("Obelix", "mail", "com"), ("Diego ", "mail", "com"), (12, 1, -301) , "¡¡Estos romanos deben de estar locos..!!"), (("Goliat", "mail", "com"), ("Diego ", "mail", "com"), (14, 7, 2001) , "¡¡¡Creo que al final lo he conseguido!!!"));

   -- VARIABLES

   Resultado : Integer;

begin

   if Hay_Mensajes (Mensajes, Propietario, Emisor, Una_Fecha) then
      Put (" Hay mensajes antes de la fecha solicitada");
   else Put (" No hay mensajes antes de la fecha solicitada");
   end if;

--Enumeration_Boolean.Put (Hay_Mensajes(Mensajes, Propietario, Emisor, Una_Fecha)); 
--La contestacion sería True o False si utilizamos esta instanciación (quitar el comentario de la linea
--9 y de la linea 200 y poner como comentario el párrafo anterior). 

   New_Line (2);
   Put (" Cuantos mensajes entre Fechas??: ");
   Resultado := Cuantos_Mensajes_Entre (Mensajes, Propietario, Primera_Fecha, Segunda_Fecha);
   Put (Resultado);
   Skip_Line(1);

end Prac1;