public class Individuo {
    PVector posicion; // Posición del individuo
    PVector velocidad; // Velocidad del individuo
    int estado; //0: Sano , 1: Enfermo, 2: Recuperado
    color c; //Color del círculo: Rojo si está enfermo, Verde si está sano, Azul si está recuperado
    boolean con_mascarilla; // Indica si un individuo usa o no mascarilla
    float m; // Utilizado para las colisiones
    boolean en_casa; // Indica si un individuo está o no en casa
    int tiempo_enfermo; // Tiempo que un individuo lleva enfermo

    //Constructor de la clase Individuo.
    Individuo(int estado, boolean con_mascarilla, boolean en_casa)
    {
        this.estado = estado;
        this.con_mascarilla = con_mascarilla;
        this.en_casa = en_casa;
        
        if(estado == 0)
        {
            this.c = color(0,255,63); //color sano
        }
        
        else if(estado == 1)
        {
            this.tiempo_enfermo = 0;
            this.estado = 1;
            this.c = color(255,0,63); //color enfermo
        }
        
        else
        {
            this.c = color(63,0,255); //color recuperado
        }
    }
    
    // Función utilizada para cambiar el estado de un individuo a enfermo
    void enfermar()
    {
        this.tiempo_enfermo = 0;
        this.estado = 1;
        this.c = color(255,0,63); //color enfermo
    }
    
    // Función utilizada para cambiar el estado de un individuo a recuperado
    void recuperarse(int tiempo_maximo_enfermo)
    {
        // Si el sujeto está enfermo, pero su tiempo de enfermo es mayor que el tiempo máximo de enfermo, entonces se recupera
        if(this.estado == 1 && this.tiempo_enfermo > tiempo_maximo_enfermo)
        {
            this.estado = 2;
            this.c = color(63,0,255); //color recuperado
        }
        
    }
    
    // Función utilizada para generar un círculo que representa al individuo en la grilla y un rectángulo en caso de que el individuo tenga mascarilla
    void mostrar(float radio)
    {
         color blanco = color(255,255,255);
         stroke(c); 
         fill(c);
         ellipse(this.posicion.x,this.posicion.y,radio*2,radio*2);
         
         // Si se tiene mascarilla, se dibuja un rectángulo blanco
         if(this.con_mascarilla)
         {
             stroke(blanco); 
             fill(blanco);
             rectMode(CENTER);
             rect(this.posicion.x,this.posicion.y,radio*2,radio);
         }
         
         this.m = radio*0.1;
   
    }
    
    // Asigna una posición inicial al individuo.
    void establecerPosicion()
    {
        PVector pos = new PVector(random(0,1023),random(0,1023));
        this.posicion = pos;
    }
    
    // Asigna una velocidad al individuo. Si se encuentra en casa, la velocidad es 0.
    void establecerVelocidad(float vel)
    {
        // Si el sujeto no está en casa se asigna velocidad
        if(!this.en_casa)
        {
            PVector vel_random = PVector.random2D();
            float vel_x =  vel_random.x * vel;
            float vel_y =  vel_random.y * vel;
            PVector velocidad = new PVector(vel_x, vel_y);  
            this.velocidad = velocidad;
        }
        
        else
        {
            PVector velocidad = new PVector(0,0);
            this.velocidad = velocidad ;
        }

    }
    
    // Función que actualiza tiempo que un individuo lleva enfermo.
    void actualizarTiempoEnfermo()
    {
        // Si el individuo está enfermo, se aumenta su tiempo de enfermo
        if(this.estado == 1)
        {
            this.tiempo_enfermo++;
        }
    }

    // Cambia la posición del individuo dependiendo de su velocidad.
    void caminar()
    {
        this.posicion = posicion.add(velocidad); 
        
        if(this.posicion.x > width)
        {
            this.posicion.x = 0;
        }
        
        else if(this.posicion.x < 0)
        {
            this.posicion.x = width;
        }
        
        else if(posicion.y > height)
        {
            this.posicion.y = 0;
        }
        
        else if(this.posicion.y < 0)
        {
            this.posicion.y = height;
        }
    }
    
    // Chequea colisiones y las produce en caso de que esté activada la opción
    void chequearColision(ArrayList<Individuo> individuos, float min_distancia) 
    {
        for (Individuo otro: individuos)
        { 
            // Si ninguno de los 2 sujetos está en casa, entonces pueden colisionar
            if(!this.en_casa && !otro.en_casa)
            {
                PVector distancia_vector = PVector.sub(otro.posicion, posicion);
            
                float distancia_vector_mag = distancia_vector.mag();
                        
                if (distancia_vector_mag < min_distancia) 
                {
                    float correccion_distancia = (min_distancia - distancia_vector_mag)/2.0;
                    PVector d = distancia_vector.copy();
                    PVector correccion_vector = d.normalize().mult(correccion_distancia);
                    otro.posicion.add(correccion_vector);
                    posicion.sub(correccion_vector);
              
                    float theta  = distancia_vector.heading();
                    float sine = sin(theta);
                    float cosine = cos(theta);
     
                    PVector[] b_temp = {
                      new PVector(), new PVector()
                    };
    
                    b_temp[1].x  = cosine * distancia_vector.x + sine * distancia_vector.y;
                    b_temp[1].y  = cosine * distancia_vector.y - sine * distancia_vector.x;
              
                    PVector[] v_temp = {
                      new PVector(), new PVector()
                    };
              
                    v_temp[0].x  = cosine * velocidad.x + sine * velocidad.y;
                    v_temp[0].y  = cosine * velocidad.y - sine * velocidad.x;
                    v_temp[1].x  = cosine * otro.velocidad.x + sine * otro.velocidad.y;
                    v_temp[1].y  = cosine * otro.velocidad.y - sine * otro.velocidad.x;
  
                    PVector[] v_final = {  
                      new PVector(), new PVector()
                    };
              
                    v_final[0].x = ((m - otro.m) * v_temp[0].x + 2 * otro.m * v_temp[1].x) / (m + otro.m);
                    v_final[0].y = v_temp[0].y;
              
                    v_final[1].x = ((otro.m - m) * v_temp[1].x + 2 * m * v_temp[0].x) / (m + otro.m);
                    v_final[1].y = v_temp[1].y;
              
                    b_temp[0].x += v_final[0].x;
                    b_temp[1].x += v_final[1].x;
              
                    PVector[] b_final = { 
                      new PVector(), new PVector()
                    };
              
                    b_final[0].x = cosine * b_temp[0].x - sine * b_temp[0].y;
                    b_final[0].y = cosine * b_temp[0].y + sine * b_temp[0].x;
                    b_final[1].x = cosine * b_temp[1].x - sine * b_temp[1].y;
                    b_final[1].y = cosine * b_temp[1].y + sine * b_temp[1].x;
  
                    posicion.add(b_final[0]);
              
                    velocidad.x = cosine * v_final[0].x - sine * v_final[0].y;
                    velocidad.y = cosine * v_final[0].y + sine * v_final[0].x;
                    otro.velocidad.x = cosine * v_final[1].x - sine * v_final[1].y;
                    otro.velocidad.y = cosine * v_final[1].y + sine * v_final[1].x;
               }
           }
       }
    }
    
    // Mantiene la velocidad de los individuos constante luego de una colisión
    void normalizarVelocidad(float vel)
    {
        float magnitud_velocidad = this.velocidad.mag();
        
        // Si el individuo no está en casa
        if(!this.en_casa)
        {
            this.velocidad = (this.velocidad.div(magnitud_velocidad)).mult(vel); 
        }
    }
    
    // Chequea si un individuo enfermo está muy cerca de uno sano, teniendo una probabilidad de enfermarlo
    void chequearDistancia(ArrayList<Individuo> individuos, float distancia_social, float p_transmision)
    {
        
        for (Individuo otro: individuos)
        { 
            float r_transmision = random(0,1);
            float p_transmision_mascarilla = p_transmision; 

            if(!this.en_casa && !otro.en_casa) // Ninguno de los 2 está en casa
            {
                if(!this.con_mascarilla && !otro.con_mascarilla) // Ninguno de los 2 ocupa mascarilla
                {
                    float distancia = PVector.dist(otro.posicion, this.posicion);

                    // En caso de que la distancia entre 2 sujetos sea menor que la distancia social y uno esté enfermo y el otro sano
                    if ((distancia > 0 && distancia <= distancia_social*1.1 && otro.estado == 1 && this.estado == 0) || (distancia > 0 && distancia <= distancia_social*1.1 && otro.estado == 0 && this.estado == 1) ) 
                    {
                        if(p_transmision >= r_transmision)
                        {
                            otro.enfermar();
                            this.enfermar();
                        }
                    }  
                }
                
                else if(this.con_mascarilla && !otro.con_mascarilla || !this.con_mascarilla && otro.con_mascarilla ) // 1 de los 2 ocupa mascarilla
                {

                   p_transmision_mascarilla = p_transmision_mascarilla * (0.2); //Al usar 1 mascarilla, se reduce en 0.8 la probabilidad de contagio

                    float distancia = PVector.dist(otro.posicion, this.posicion);
                
                    // En caso de que la distancia entre 2 sujetos sea menor que la distancia social y uno esté enfermo y el otro sano
                    if ((distancia > 0 && distancia <= distancia_social*1.1 && otro.estado == 1 && this.estado == 0) || (distancia > 0 && distancia <= distancia_social*1.1 && otro.estado == 0 && this.estado == 1) ) 
                    {
                        if(p_transmision_mascarilla >= r_transmision)
                        {
                            otro.enfermar();
                            this.enfermar();
                        }
                    }  
                }
                
                else
                {
                      p_transmision_mascarilla = p_transmision_mascarilla * (0.01); //Al usar 1 mascarilla, se reduce en 0.99 la probabilidad de contagio
                  
                      float distancia = PVector.dist(otro.posicion, this.posicion);
          
                      // En caso de que la distancia entre 2 sujetos sea menor que la distancia social y uno esté enfermo y el otro sano
                      if ((distancia > 0 && distancia <= distancia_social*1.1 && otro.estado == 1 && this.estado == 0) || (distancia > 0 && distancia <= distancia_social*1.1 && otro.estado == 0 && this.estado == 1) ) 
                      {
                          if(p_transmision_mascarilla >= r_transmision)
                          {
                              otro.enfermar();
                              this.enfermar();
                          }
                      }  
                 }   
            }
        }
    }
}
