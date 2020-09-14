public class Individuo {
    PVector posicion; // Posición del individuo
    PVector velocidad; // Velocidad del individuo
    PVector aceleracion;  //Aceleración del individuo
    Boolean enfermo; //Si está o no enfermo
    int tipo_caminata; //0: caminar aleatorio ; 1: caminar alternativo
    color c; //Color del círculo: Rojo si está enfermo, Verde si está sano.
    
    //Constructor de la clase Individuo.
    Individuo(color c, boolean enfermo, int tipo_caminata)
    {
        this.enfermo = enfermo;
        this.c = c;
        this.tipo_caminata = tipo_caminata;
    }
    
    // Función utilizada para generar un círculo que representa al individuo en la grilla.
    void mostrar()
    {
         stroke(c); 
         fill(c);
         ellipse(posicion.x,posicion.y,10,10);
    }
    
    // Asigna una posición inicial al individuo.
    void establecerPosicion()
    {
        PVector pos = new PVector(random(0,1023),random(0,1023));
        posicion = pos;
    }
    
    // Asigna una velocidad al individuo, que puede ser de tipo caminata aleatoria (horizontal) o caminata alternativa (vertical y horizontal)
    void establecerVelocidad(float s)
    {
        if(tipo_caminata == 0)
        {
            PVector vel = new PVector(randomGaussian(), 0);  
            velocidad = vel;
        }
        
        else
        {
            float vel_x =  s*cos(random(TWO_PI));
            float vel_y =  s*sin(random(TWO_PI));
            PVector vel = new PVector(vel_x, vel_y);  
            velocidad = vel;
        }

    }
    
    //No se utiliza aún
    void establecerAceleracion() 
    {
        PVector acel = new PVector(0, 0);  
        aceleracion = acel;
    }
    
    // Cambia la posición del individuo dependiendo de su velocidad.
    void caminar()
    {
        posicion = posicion.add(velocidad); 
        
        if(posicion.x > width)
        {
            posicion.x = 0;
        }
        
        else if(posicion.x < 0)
        {
            posicion.x = width;
        }
        
        else if(posicion.y > height)
        {
            posicion.y = 0;
        }
        
        else if(posicion.y < 0)
        {
            posicion.y = height;
        }
    }
}
