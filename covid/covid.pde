ArrayList<Individuo> individuos = new ArrayList<Individuo>();
int cantidadIndividuos = 300;

void setup() {
    size(1024, 1024);
    for(int i=0; i<cantidadIndividuos;i++)
    {
        Individuo individuo = new Individuo();
        individuo.establecerPosicion();
        individuo.establecerVelocidad();
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
    for(int i=0; i<cantidadIndividuos; i++)
    {
        //individuos.get(i).obtenerPosicion();
        individuos.get(i).mostrar();
        individuos.get(i).caminar();
    }
}
