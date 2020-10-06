ArrayList<Individuo> individuos = new ArrayList<Individuo>(); // Lista de individuos

float radio = 8.0; // radio del individuo
float vel = 2.0; // velocidad individuos
float min_distancia = 2*radio;  //distancia mínima entre sujetos
float distancia_social = 1.0 * min_distancia;  //distancia social para no contagiarse
float p_en_casa = 0.1; // probabilidad de que un individuo se quede en casa
float p_transmision = 0.9; // probabilidad de que un enfermo contagie a un sano
float p_enfermo = 0.4 ; // probabilidad de que un individuo esté enfermo 
float p_mascarilla = 0.6; // probabilidad de que un individuo use mascarilla
int tiempo_maximo_enfermo = 500; // tiempo máximo para que un enfermo pase a recuperado
int cantidad_individuos = 60; // Cantidad de individuos
boolean colision = true; // establece si habrán colisiones o no


//Se establecen las configuraciones iniciales, tales como creación de la grilla e inicialización de individuos.
void setup() {
    size(1024, 1024);
    for(int i=0; i < cantidad_individuos; i++)
    {
        float r_enfermo = random(0,1);
        float r_mascarilla = random(0,1);
        float r_en_casa = random(0,1);
        Individuo individuo;
        
        if(p_enfermo >= r_enfermo)
        {
            if(p_mascarilla >= r_mascarilla)
            {
                if( p_en_casa >= r_en_casa)
                {
                    individuo = new Individuo(1, true, true);
                }
                
                else
                {
                    individuo = new Individuo(1, true, false);
                }
            }
            
            else
            {
                if( p_en_casa >= r_en_casa)
                {
                    individuo = new Individuo(1, false, true);
                }
                
                else
                {
                    individuo = new Individuo(1, false, false);
                }            
             }
        }
        
        else
        {
            if(p_mascarilla >= r_mascarilla)
            {
                if( p_en_casa >= r_en_casa)
                {
                    individuo = new Individuo(0, true, true);
                }
                
                else
                {
                    individuo = new Individuo(0, true, false);
                }            
            }
            
            else
            {
                if( p_en_casa >= r_en_casa)
                {
                    individuo = new Individuo(0, false, true);
                }
                
                else
                {
                    individuo = new Individuo(0, false, false);
                }               
             }          
        }
        
        individuo.establecerPosicion();
        individuo.establecerVelocidad(vel);
        individuos.add(individuo);  
    }
}

// Función que mantiene actualizados el estado de los individuos. Se actualiza constantemente para mostrarlos.
void draw()
{
    background(0);
    mostrarIndividuos(); // Muestra a los individuos en la grilla
    chequearColision(); // Chequea colisiones y las produce en caso de que esté activada la opción
    chequearDistanciaSocial(); // Chequea si un individuo enfermo está muy cerca de uno sano, teniendo una probabilidad de enfermarlo
    chequearEstadoIndividuo();  // Chequea el tiempo de enfermo para que un individuo pase a recuperado
}

// Función que recorre a todos los individuos para mostrarlos, establecer su velocidad y hacerlos caminar.
void mostrarIndividuos()
{  
    for(int i=0; i<cantidad_individuos; i++)
    {
        individuos.get(i).mostrar(radio);
        individuos.get(i).caminar();
    }
}

// Chequea el tiempo de enfermo para que un individuo pase a recuperado
void chequearEstadoIndividuo()
{
    for(int i=0; i<cantidad_individuos; i++)
    {
        individuos.get(i).actualizarTiempoEnfermo();
        individuos.get(i).recuperarse(tiempo_maximo_enfermo);
    }
}

// Chequea colisiones y las produce en caso de que esté activada la opción
void chequearColision()
{
    for(int i=0; i<cantidad_individuos; i++)
        {
            if(colision)
            {
                individuos.get(i).chequearColision(individuos, min_distancia);
                individuos.get(i).normalizarVelocidad(vel);
            }
        }     
}

// Chequea si un individuo enfermo está muy cerca de uno sano, teniendo una probabilidad de enfermarlo
void chequearDistanciaSocial()
{
    for(int i=0; i < cantidad_individuos; i++)
    {
        individuos.get(i).chequearDistancia(individuos, distancia_social, p_transmision);
    }     
}
