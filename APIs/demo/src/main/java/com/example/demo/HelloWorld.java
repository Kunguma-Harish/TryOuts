package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorld {
    @GetMapping
    public DummyStruct getEmp() {
        String name = "Kungu";
        int id = 14252;
        return new DummyStruct(id, name);
    }

    @GetMapping("/getEmp/{id}")
    public DummyStruct getEmpById(@PathVariable int id) {
        return new DummyStruct(id, "KunguHarish");
    }

    @GetMapping("/getEmpByUser")
    public DummyStruct getEmpByUser(@RequestParam String name) {
        return new DummyStruct(14252, name);
    }
}
