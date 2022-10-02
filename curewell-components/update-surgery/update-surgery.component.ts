import { ActivatedRoute, Router } from '@angular/router';
import { Component, OnInit } from '@angular/core';
import { Injectable } from '@angular/core';
import { CurewellService } from '../../curewell-services/curewell.service';
import { Surgery } from '../../curewell-interfaces/surgery';

@Component({
  templateUrl: './update-surgery.component.html'
})
export class UpdateSurgeryComponent implements OnInit {

  doctorId: number;
  surgeryId: number;
  surgeryDate: Date;
  startTime: number;
  endTime: number;
  surgeryCategory: string;
  status: boolean;
  errorMsg: string;

  constructor(private route: ActivatedRoute, private _cureWellService: CurewellService, private router: Router) { }

  ngOnInit() {
    //To do implement necessary logic
    this.doctorId = parseInt(this.route.snapshot.params['doctorId']);
    this.surgeryId = parseInt(this.route.snapshot.params['surgeryId']);
    this.surgeryDate = this.route.snapshot.params['surgeryDate'];
    this.startTime = parseInt(this.route.snapshot.params['startTime']);
    this.endTime = parseInt(this.route.snapshot.params['endTime']);
    this.surgeryCategory = this.route.snapshot.params['surgeryCategory'];
    


  }

  editSurgery(startTime: number, endTime: number) {
    //To do implement necessary logic
    this.startTime = parseInt(<any>startTime);
    this.endTime = parseInt(<any>endTime);
    console.log(this.startTime, this.endTime)
    this._cureWellService.editSurgery(this.doctorId, this.endTime, this.startTime, this.surgeryCategory, this.surgeryDate, this.surgeryId).subscribe(
      res => {
        this.status = res;
        if (this.status) {
          alert("Surgery Details Updated Successfully!")
          this.router.navigate(['/viewTodaySurgery']);
        }
        else {
          alert("Surgery Details not updated")
          this.router.navigate(['/viewTodaySurgery']);
        }
      },
      re => {
        this.errorMsg = re;
        alert("Some error occurred")
        this.router.navigate(['/viewTodaySurgery']);
      },
      ()=> console.log("Updated surgery details successfully")
    );
  }
}
