public class Individuo {
    PVector posicion;
    PVector velocidad;
    PVector aceleracion;  
    Boolean enfermo;
    int tipo_caminata; //0: caminar aleatorio ; 1: caminar alternativo
    color c;
    
    Individuo(color c, boolean enfermo, int tipo_caminata)
    {
        this.enfermo = enfermo;
        this.c = c;
        this.tipo_caminata = tipo_caminata;
    }
      
    void mostrar()
    {
         stroke(c); 
         fill(c);
         ellipse(posicion.x,posicion.y,10,10);
    }
    
    void establecerPosicion()
    {
        PVector pos = new PVector(random(0,1023),random(0,1023));
        posicion = pos;
    }
    
    void establecerVelocidad(int s)
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
    
    
    void caminar()
    {
        posicion = posicion.add(velocidad); // (10, 25) + (-1, -1) -> (9, 24) -> (8, 23)
        
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
