public class Individuo {
    int id;
    PVector posicion; // Posición del individuo
    PVector velocidad; // Velocidad del individuo
    PVector aceleracion;  //Aceleración del individuo
    int estado; //0: Sano , 1: Enfermo, 2: Recuperado
    color c; //Color del círculo: Rojo si está enfermo, Verde si está sano.
    boolean con_mascarilla;
    float m;

    //Constructor de la clase Individuo.
    Individuo(int id, int estado, boolean con_mascarilla)
    {
        this.id = id;
        this.estado = estado;
        this.con_mascarilla = con_mascarilla;

        if(estado == 0)
        {
            this.c = color(0,255,63); //color sano
            
        }
        
        else if(estado == 1)
        {
            this.estado = 1;
            this.c = color(255,0,63); //color enfermo
        }
        
        else
        {
            this.c = color(63,0,255); //color recuperado
        }
    }
    
    void enfermar()
    {
        this.estado = 1;
        this.c = color(255,0,63); //color enfermo
    }
    
    void recuperarse()
    {
        this.estado = 2;
        this.c = color(63,0,255); //color recuperado
    }
    
    
    // Función utilizada para generar un círculo que representa al individuo en la grilla.
    void mostrar(int radio)
    {
         color blanco = color(255,255,255);
         stroke(c); 
         fill(c);
         ellipse(posicion.x,posicion.y,radio*2,radio*2);
         
         if(this.con_mascarilla)
         {
             stroke(blanco); 
             fill(blanco);
             rectMode(CENTER);
             rect(posicion.x,posicion.y,radio*2,radio);
         }
         
         this.m = radio*0.1;
   
    }
    
    // Asigna una posición inicial al individuo.
    void establecerPosicion()
    {
        PVector pos = new PVector(random(0,1023),random(0,1023));
        posicion = pos;
    }
    
    // Asigna una velocidad al individuo, que puede ser de tipo caminata aleatoria (horizontal) o caminata alternativa (vertical y horizontal)
    void establecerVelocidad(float vel)
    {
        PVector vel_random = PVector.random2D();
        float vel_x =  vel_random.x * vel;
        float vel_y =  vel_random.y * vel;
        PVector velocidad = new PVector(vel_x, vel_y);  
        this.velocidad = velocidad;
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
    
    void chequearColision(ArrayList<Individuo> individuos, float min_distancia) 
    {
       
        for (Individuo other: individuos)
        { 
             // Get distances between the balls components
            PVector distanceVect = PVector.sub(other.posicion, posicion);
        
            // Calculate magnitude of the vector separating the balls
            float distanceVectMag = distanceVect.mag();
        
            // Minimum distance before they are touching
            float minDistance = min_distancia;
        
            if (distanceVectMag < minDistance) {
              float distanceCorrection = (minDistance-distanceVectMag)/2.0;
              PVector d = distanceVect.copy();
              PVector correctionVector = d.normalize().mult(distanceCorrection);
              other.posicion.add(correctionVector);
              posicion.sub(correctionVector);
        
              // get angle of distanceVect
              float theta  = distanceVect.heading();
              // precalculate trig values
              float sine = sin(theta);
              float cosine = cos(theta);
        
              /* bTemp will hold rotated ball positions. You 
               just need to worry about bTemp[1] position*/
              PVector[] bTemp = {
                new PVector(), new PVector()
              };
        
              /* this ball's position is relative to the other
               so you can use the vector between them (bVect) as the 
               reference point in the rotation expressions.
               bTemp[0].position.x and bTemp[0].position.y will initialize
               automatically to 0.0, which is what you want
               since b[1] will rotate around b[0] */
              bTemp[1].x  = cosine * distanceVect.x + sine * distanceVect.y;
              bTemp[1].y  = cosine * distanceVect.y - sine * distanceVect.x;
        
              // rotate Temporary velocities
              PVector[] vTemp = {
                new PVector(), new PVector()
              };
        
              vTemp[0].x  = cosine * velocidad.x + sine * velocidad.y;
              vTemp[0].y  = cosine * velocidad.y - sine * velocidad.x;
              vTemp[1].x  = cosine * other.velocidad.x + sine * other.velocidad.y;
              vTemp[1].y  = cosine * other.velocidad.y - sine * other.velocidad.x;
        
              /* Now that velocities are rotated, you can use 1D
               conservation of momentum equations to calculate 
               the final velocity along the x-axis. */
              PVector[] vFinal = {  
                new PVector(), new PVector()
              };
        
              // final rotated velocity for b[0]
              vFinal[0].x = ((m - other.m) * vTemp[0].x + 2 * other.m * vTemp[1].x) / (m + other.m);
              vFinal[0].y = vTemp[0].y;
        
              // final rotated velocity for b[1]
              vFinal[1].x = ((other.m - m) * vTemp[1].x + 2 * m * vTemp[0].x) / (m + other.m);
              vFinal[1].y = vTemp[1].y;
        
              // hack to avoid clumping
              bTemp[0].x += vFinal[0].x;
              bTemp[1].x += vFinal[1].x;
        
              /* Rotate ball positions and velocities back
               Reverse signs in trig expressions to rotate 
               in the opposite direction */
              // rotate balls
              PVector[] bFinal = { 
                new PVector(), new PVector()
              };
        
              bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
              bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
              bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
              bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;
        
              // update balls to screen position
              //other.posicion.x = posicion.x + bFinal[1].x;
              //other.posicion.y = posicion.y + bFinal[1].y;
        
              posicion.add(bFinal[0]);
        
              // update velocities
               velocidad.x = cosine * vFinal[0].x - sine * vFinal[0].y;
               velocidad.y = cosine * vFinal[0].y + sine * vFinal[0].x;
               other.velocidad.x = cosine * vFinal[1].x - sine * vFinal[1].y;
               other.velocidad.y = cosine * vFinal[1].y + sine * vFinal[1].x;
            }
        }
    }
    
    boolean chequearDistancia(ArrayList<Individuo> individuos, float distancia_social)
    {
        for (Individuo other: individuos)
        { 
             // Get distances between the balls components
            float distancia = PVector.dist(other.posicion, this.posicion);

            if ((distancia > 0 && distancia < distancia_social && other.estado == 1 && this.estado == 0) || (distancia > 0 && distancia < distancia_social && other.estado == 0 && this.estado == 1) ) 
            {
                println("Me puedo contagiar");
                return true; // Me puedo contagiar
            }  
            
            else
            {
                return false; // No me puedo contagiar
            }
        }
        
        return true;
    }
}
