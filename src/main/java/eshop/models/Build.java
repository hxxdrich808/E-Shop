package eshop.models;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "Builds")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Build {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    private Long id;
    @Column(name = "cpu")
    private String cpu;
    @Column(name = "motherboard")
    private String motherboard;
    @Column(name = "ram")
    private String ram;
    @Column(name = "gpu")
    private String gpu;
    @Column(name = "psu")
    private String psu;
    @Column(name = "drive")
    private String drive;
    @Column(name = "systemUnit")
    private String systemUnit;
    @Column(name = "cooler")
    private String cooler;
}
