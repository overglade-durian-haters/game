## Level ZIP

Each level is ZIP containing a `level.json` and a `level.wav`. The level JSON structure is shown
below.

```json
{
	"title": "",
	"events": [
		{
			"type": "spawn_hand",
			"time": 0.0,
			"id": 1,
			"bpm": 60.0,
			"stride": 5,
			"initial_offset": 0
		},
		{
			"type": "modify_hand",
			"time": 2.0,
			"id": 1,
			"bpm": 120.0,
			"stride": 5
		},
		{
			"type": "remove_hand",
			"time": 4.0,
			"id": 1
		}
	]
}
```
