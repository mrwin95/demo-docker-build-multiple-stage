package com.example.demodockerbuildmultiplestage;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.amqp.*;
import org.springframework.kafka.event.*;
@SpringBootApplication
public class DemoDockerBuildMultipleStageApplication {

    public static void main(String[] args) {
        SpringApplication.run(DemoDockerBuildMultipleStageApplication.class, args);
    }

}
