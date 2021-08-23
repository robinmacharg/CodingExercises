**For notes on the submitted code please see [the README_submission.md](Superheroes/README_submission.md) document in the Superheroes subdirectory.**

## Tech stack

- Swift
- AppKit (no SwiftUI)
- No 3rd party libraries

## ETA

3-4 hours

## TODO

### Implement an application with the following features:

- Create data structure that will be used for JSON (sample is provided below);
- Fill data structure with random data;
- Send request `POST` to `https://httpbin.org/anything`;
- Parse response and display JSON tree from `data` field;
- Keep history of requests/responses and allow to switch between them;

### General requirements

- All non-UI operation must be executed on non-main thread;
- Make nice UI;
- Push your solution to a public github repo and provide setup instructions if any;

## Sample JSON

Sample:
```
{
    "squadName": "Super hero squad",
    "homeTown": "Metro City",
    "formed": 2016,
    "active": true,
    "members": [
        {
            "name": "Molecule Man",
            "age": 29,
            "secretIdentity": "Dan Jukes",
            "powers": ["Radiation resistance", "Turning tiny", "Radiation blast"]
        },
        {
            "name": "Madame Uppercut",
            "age": 39,
            "secretIdentity": "Jane Wilson",
            "powers": ["Million tonne punch", "Damage resistance", "Superhuman reflexes"]
        },
        {
            "name": "Eternal Flame",
            "age": 1000000,
            "secretIdentity": "Unknown",
            "powers": ["Immortality", "Heat Immunity", "Inferno", "Teleportation", "Interdimensional travel"]
        }
    ]
}
```
