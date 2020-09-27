ArrayList<Individuo> individuos = new ArrayList<Individuo>(); // Lista de individuos
int cantidad_individuos = 10; // Cantidad de individuos
float vel = 2; // velocidad individuos
float p_enfermo = 0.3 ; // probabilidad de que un individuo esté enfermo 
float p_mascarilla = 0.0;
float p_transmision = 1;
int radio = 8;
float min_distancia = 2*radio;
boolean colision = false;
float distancia_social = 1.5 * min_distancia;

//Se establecen las configuraciones iniciales, tales como creación de la grilla e inicialización de individuos.
void setup() {
    size(1024, 1024);
    for(int i=0; i < cantidad_individuos; i++)
    {
        float r_enfermo = random(0,1);
        float r_mascarilla = random(0,1);

        Individuo individuo;
        
        if(p_enfermo >= r_enfermo)
        {
            if(p_mascarilla >= r_mascarilla)
            {
                individuo = new Individuo(i,1, true);
            }
            
            else
            {
                individuo = new Individuo(i,1, false);
            }
        }
        
        else
        {
            if(p_mascarilla >= r_mascarilla)
            {
                individuo = new Individuo(i,0, true);
            }
            
            else
            {
                individuo = new Individuo(i,0, false);
            }          
        }
        individuo.establecerPosicion();
        individuo.establecerVelocidad(vel);
        individuos.add(individuo);
        
        println(individuo.id, individuo.estado);
        
    }
}

// Función que mantiene actualizados el estado de los individuos. Se actualiza constantemente para mostrarlos.
void draw()
{
    background(0);
    mostrarIndividuos();
    chequearColision();
    chequearDistanciaSocial();
}

// Función que recorre a todos los individuos para mostrarlos, establecer su velocidad y hacerlos caminar.
void mostrarIndividuos()
{  
    for(int i=0; i<cantidad_individuos; i++)
    {
        //individuos.get(i).obtenerPosicion();
        individuos.get(i).mostrar(radio);
        individuos.get(i).caminar();
    }
}

void chequearColision()
{
    for(int i=0; i<cantidad_individuos; i++)
        {
            if(colision)
            {
                individuos.get(i).chequearColision(individuos, min_distancia);
            }
        }     
}

void chequearDistanciaSocial()
{
    for(int i=0; i<cantidad_individuos; i++)
    {
        if(individuos.get(i).chequearDistancia(individuos, distancia_social) == true)
        {
            float r_transmision = random(0,1);
            if(p_transmision >= r_transmision)
            {
                println("entreeeeeeeeeee");
                individuos.get(i).enfermar();
            }
        }
    }     
}
