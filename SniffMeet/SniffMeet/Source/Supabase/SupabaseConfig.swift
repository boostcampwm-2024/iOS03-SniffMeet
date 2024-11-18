//
//  SupabaseManager.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/17/24.
//

import Foundation

enum SupabaseConfig {
    static var session: SupabaseSession?
    static let baseURL = URL(string: "https://lltjsznuclppbhxfwslo.supabase.co")!
    static let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxsdGpzem51Y2xwcGJoeGZ3c2xvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE0MDA5MjgsImV4cCI6MjA0Njk3NjkyOH0.qrzmB2tiwWevRhKQeptsf5m8iCLUIkscuQ1MzKNtqh4" // 공개키
}
