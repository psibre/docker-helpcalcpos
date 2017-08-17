# docker-helpcalcpos

Dockerized **HelpCalcpos** wrapper for raw AG500 EMA data processing with **CalcPos**

## Scenario

Given some raw EMA data recorded on a [Carstens] AG500 articulograph, you want to calculate the positions of the EMA coils.
This is not 2005, so you want to do this efficiently, with parallel processing helper jobs, on a modern PC.

## Prerequisites

To run this, you will need to have [Docker] installed, and for parallel processing, also `docker-compose`.
To run the **CalcPos** client GUI, you will need the [CalcPos] Windows binary, which can be run through [Wine].

## Running

To run the actual [Docker container], just run
```
$ docker run -e CLIENT=[CLIENT] -t psibre/helpcalcpos
```
replacing `[CLIENT]` with the hostname of the machine that will be running the **CalcPos** GUI client (through Wine or natively).

### Example

```
$ docker run -e CLIENT=foo -t psibre/helpcalcpos
Creating DataModule ..HelperVersion : 0.89
DataModule created.
Calling Run.
connecting to foo
Connecting ...
```

## Running *efficiently*

Each `HelpCalcpos` process is single-threaded, so to run multiple helpers, we need multiple processes. Or more elegantly, multiple services running together, where each service runs one `HelpCalcpos` process.
This is where `docker-compose` comes in.

Just run
```
$ CLIENT=[CLIENT] docker-compose up --scale helpcalcpos=[N]
```
where `[CLIENT]` is the hostname of the machine that will be running the CalcPos GUI client, and `[N]` is the number of services you want to spawn.
Incidentally, it appears the maximum number of helpers is limited to **30**.

On **older versions of `docker-compose`**, run
```
$ CLIENT=[CLIENT] docker-compose scale helpcalcpos=[N]
```

### Example

```
$ CLIENT=foo docker-compose up --scale helpcalcpos=4
Starting dockerhelpcalcpos_helpcalcpos_1 ... done
Starting dockerhelpcalcpos_helpcalcpos_2 ... done
Starting dockerhelpcalcpos_helpcalcpos_3 ... done
Starting dockerhelpcalcpos_helpcalcpos_4 ... done
Attaching to dockerhelpcalcpos_helpcalcpos_1, dockerhelpcalcpos_helpcalcpos_2, dockerhelpcalcpos_helpcalcpos_3, dockerhelpcalcpos_helpcalcpos_4
helpcalcpos_1  | Creating DataModule ..HelperVersion : 0.89
helpcalcpos_1  | DataModule created.
helpcalcpos_1  | Calling Run.
helpcalcpos_1  | connecting to foo
helpcalcpos_3  | Creating DataModule ..HelperVersion : 0.89
helpcalcpos_3  | DataModule created.
helpcalcpos_3  | Calling Run.
helpcalcpos_3  | connecting to foo
helpcalcpos_2  | Creating DataModule ..HelperVersion : 0.89
helpcalcpos_2  | DataModule created.
helpcalcpos_2  | Calling Run.
helpcalcpos_2  | connecting to foo
helpcalcpos_4  | Creating DataModule ..HelperVersion : 0.89
helpcalcpos_4  | DataModule created.
helpcalcpos_4  | Calling Run.
helpcalcpos_4  | connecting to foo
```

## Running **CalcPos**

Once Docker or `docker-compose` indicates that the `HelpCalcpos` processes are ready (i.e., "connecting to foo", above), it's time to start the **CalcPos** GUI on machine *foo* (replace as appropriate).
To verify that the helper threads are really available, you can click the "extras" button, expand the "experimental" pane, and click on the "show JobDispatcher" button, which will pop up another window; there the number of "helpers available" in the status bar should correspond to the services running via Docker or `docker-compose`.

[Carstens]: http://www.articulograph.de/
[Docker]: https://www.docker.com/
[CalcPos]: http://www.ag500.de/calcpos/CalcPos.zip
[Wine]: https://www.winehq.org/
[Homebrew]: https://brew.sh/
[Docker container]: https://hub.docker.com/r/psibre/helpcalcpos/
