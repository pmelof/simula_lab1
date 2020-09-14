ArrayList<Individuo> individuos = new ArrayList<Individuo>();
int cantidad_individuos = 300;
int s = 2; // s es el factor que multiplica en x = x + s * cos(tetha) 
float p_enfermo = 0.1 ; // probabilidad enfermo 
int tipo_caminata = 1;

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

void draw()
{
    background(0);
    mostrarIndividuos();
}

void mostrarIndividuos()
{  
    for(int i=0; i<cantidad_individuos; i++)
    {
        //individuos.get(i).obtenerPosicion();
        individuos.get(i).mostrar();
        individuos.get(i).establecerVelocidad(s);
        individuos.get(i).caminar();
    }
}
