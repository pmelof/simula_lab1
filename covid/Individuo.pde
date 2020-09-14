public class Individuo {
    PVector posicion;
    PVector velocidad;
    PVector aceleracion;  
    Boolean enfermo;
    color c;
    
    Individuo()
    {
        enfermo = false;
        c = color(0,255,63);
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
    
    void establecerVelocidad()
    {
        PVector vel = new PVector(randomGaussian(), 0);  
        velocidad = vel;
    }
    
    void caminar()
    {
        posicion = posicion.add(velocidad);
        if(posicion.x > width)
        {
            posicion.x = 0;
        }
        
        if(posicion.x < 0)
        {
            posicion.x = width;
        }
    }
}
