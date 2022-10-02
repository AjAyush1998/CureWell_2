import { Component, OnInit, DoCheck } from '@angular/core';
import { Doctor } from '../../curewell-interfaces/doctor';
import { CurewellService } from '../../curewell-services/curewell.service';
import { Router, ActivatedRoute } from '@angular/router';
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from "@angular/common/http";
import { Route } from '@angular/compiler/src/core';

@Component({
  templateUrl: './view-doctor.component.html',
})
export class ViewDoctorComponent implements OnInit {

  doctorList: Doctor[];
  showMsgDiv: boolean = false;
  doctorId: number;
  errorMsg: string;
  status: boolean;

  constructor(private _curewellService: CurewellService, private router: Router) { }

  ngOnInit() {
    //To do implement necessary logic
    this.getDoctor();
    if (this.doctorList == null) {
      this.showMsgDiv = true;
    }
  }

  getDoctor() {
    //To do implement necessary logic
    this._curewellService.getDoctors().subscribe(
      res => {
        this.doctorList = res;
        this.showMsgDiv = false;
      },
      rese => {
        this.doctorList = null;
        this.errorMsg = rese;
      },
      () => console.log("Doctors Fetched Successfully")
    );
  }

  editDoctorDetails(doctor: Doctor) {
    //To do implement necessary logic
    this.router.navigate(['/editDoctorDetails', doctor.doctorId, doctor.doctorName]);
  }

  removeDoctor(doctor: Doctor) {
    //To do implement necessary logic
    this._curewellService.deleteDoctor(doctor).subscribe(
      res => {
        this.status = res;
        if (this.status) {
          alert("Doctor details deleted successfully!");
          this.ngOnInit();
        }
        else {
          alert("Doctor's name not deleted");
        }
      },
      rere => {
        this.errorMsg = "Some error occurred";
      },
      ()=> console.log("RemoveMethod worked fine.")
     );
  }

}
