import Foundation

struct CampusResource: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let phone: String?
    let location: String?
}

enum CampusResourceDatabase {
    static let formalHelp: [CampusResource] = [
        CampusResource(
            title: "Individual Counseling",
            detail: "One-on-one sessions with a licensed counselor at the UIC Counseling Center. Confidential and free for enrolled students.",
            phone: "(312) 996-3490",
            location: "Student Services Building, Suite 2010"
        ),
        CampusResource(
            title: "Group Therapy",
            detail: "Weekly small-group sessions (4-8 students) led by 1-2 trained group therapists. No session limit, in-person or virtual.",
            phone: "(312) 996-3490",
            location: "Student Services Building, Suite 2010"
        ),
        CampusResource(
            title: "24/7 Crisis Line",
            detail: "For urgent support any time, day or night.",
            phone: "(312) 996-3490 — press 2 after hours",
            location: nil
        ),
    ]

    static let workshops: [CampusResource] = [
        CampusResource(
            title: "Mind Body Workshop",
            detail: "Guided session combining light movement and mindfulness to help reset stress levels.",
            phone: nil,
            location: "Check UIC Campus Recreation for current schedule"
        ),
        CampusResource(
            title: "Puppy Yoga Workshop",
            detail: "Yoga session with visiting therapy dogs — a relaxed, low-pressure way to de-stress.",
            phone: nil,
            location: "Check UIC Campus Recreation for current schedule"
        ),
        CampusResource(
            title: "F45 Workout Week",
            detail: "Free trial week of F45-style group workouts through Campus Recreation.",
            phone: nil,
            location: "UIC Campus Recreation Center"
        ),
    ]
}
