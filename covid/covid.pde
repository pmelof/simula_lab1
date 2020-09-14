ArrayList<Individuo> individuos = new ArrayList<Individuo>(); // Lista de individuos
int cantidad_individuos = 300; // Cantidad de individuos
float s = 0.3; // s es el factor que multiplica en x = x + s * cos(tetha) y y = y + s * sin(tetha)
float p_enfermo = 0.1 ; // probabilidad de que un individuo esté enfermo 
int tipo_caminata = 1; // 0: caminar aleatorio ; 1: caminar alternativo

//Se establecen las configuraciones iniciales, tales como creación de la grilla e inicialización de individuos.
void setup() {
    size(1024, 1024);
    for(int i=0; i<cantidad_individuos;i++)
    {
        float r = random(0,1);
        Individuo individuo;
        
        if(p_enfermo >= r)
        {
            color rojo = color(255,0,0);
            individuo = new Individuo(rojo,true,tipo_caminata);
        }
        
        else
        {
            color verde = color(0,255,0);
            individuo = new Individuo(verde,true,tipo_caminata);
        }
        individuo.establecerPosicion();
        individuo.establecerVelocidad(s);
        individuos.add(individuo);
    }
}

// Función que mantiene actualizados el estado de los individuos. Se actualiza constantemente para mostrarlos.
void draw()
{
    background(0);
    mostrarIndividuos();
}

// Función que recorre a todos los individuos para mostrarlos, establecer su velocidad y hacerlos caminar.
void mostrarIndividuos()
{  
    for(int i=0; i<cantidad_individuos; i++)
    {
        //individuos.get(i).obtenerPosicion();
        individuos.get(i).mostrar();
        if(tipo_caminata == 1)
        {
            individuos.get(i).establecerVelocidad(s);
        }
        individuos.get(i).caminar();
    }
}
