import { Injectable } from '@angular/core';
import { Doctor } from '../curewell-interfaces/doctor';
import { DoctorSpecialization } from '../curewell-interfaces/doctorspecialization';
import { Specialization } from '../curewell-interfaces/specialization';
import { Surgery } from '../curewell-interfaces/surgery';
import { HttpClient, HttpErrorResponse, HttpHeaders } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
//import { start } from 'repl';

@Injectable({
  providedIn: 'root'
})
export class CurewellService {

  doctorList: Doctor[];
  surgeryList: Surgery[];
  specializationList: Specialization[];
  doctorSpecializationList: DoctorSpecialization[];

  constructor(private http: HttpClient) { }
  
  //GetDoctor
  getDoctors(): Observable<Doctor[]> {
    //To do implement necessary logic
    let tempVar = this.http.get<Doctor[]>('http://localhost:50476/api/CureWell/GetDoctors').pipe(catchError(this.errorHandler));;
    return tempVar;
  }

  //GetSpecialization
  getAllSpecializations(): Observable<Specialization[]> {
   //To do implement necessary logic
    let tempVar = this.http.get<Specialization[]>('http://localhost:50476/api/CureWell/GetSpecializations').pipe(catchError(this.errorHandler));;
    return tempVar;
  }

  //GetSurgeries
  getAllSurgeriesForToday(): Observable<Surgery[]> {
    //To do implement necessary logic
    let tempVar = this.http.get<Surgery[]>('http://localhost:50476/api/CureWell/GetAllSurgeryTypeForToday').pipe(catchError(this.errorHandler));;
    return tempVar;
  }

  //AddDoctor
  addDoctor(doctorName: string): Observable<boolean> {
    //To do implement necessary logic
    var docObj: Doctor;
    docObj = { doctorId: 0, doctorName: doctorName };
    return this.http.post<boolean>('http://localhost:50476/api/CureWell/AddDoctor', docObj).pipe(catchError(this.errorHandler));
  }

  //EditDoctor
  editDoctorDetails(doctorId: number, doctorName: string): Observable<boolean> {
    //To do implement necessary logic
    var doc: Doctor;
    doc = { doctorId: doctorId, doctorName: doctorName };
    return this.http.put<boolean>('http://localhost:50476/api/CureWell/UpdateDoctorDetails', doc).pipe(catchError(this.errorHandler));
  }

  //editSurgery
  editSurgery(doctorId: number, endTime: number, startTime: number, surgeryCategory: string, surgeryDate: Date, surgeryId: number): Observable<boolean> {
    //To do implement necessary logic
    var sur: Surgery;
    sur = { doctorId: doctorId, endTime: endTime, startTime: startTime, surgeryCategory: surgeryCategory, surgeryDate: surgeryDate, surgeryId: surgeryId }
    return this.http.put<boolean>('http://localhost:50476/api/CureWell/UpdateSurgery', sur).pipe(catchError(this.errorHandler));
  }

  //RemoveDoctor
  deleteDoctor(doctor: Doctor) {
    //To do implement necessary logic
    
    let httpOptions = { headers: new HttpHeaders({ 'Content-Type': 'application/json' }), body: doctor };
    return this.http.delete<boolean>('http://localhost:50476/api/CureWell/DeleteDoctor', httpOptions).pipe(catchError(this.errorHandler));
  }

  //ErrorHandler
  errorHandler(error: HttpErrorResponse) {
    //To do implement necessary logic
    console.log(error);
    return throwError(error.message || 'ERROR')

  }

}
