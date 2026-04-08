export type ImpactMetric = {
  label: string
  value: number
  changePercent: number
}

export type MonthlyTrendPoint = {
  month: string
  assistedHouseholds: number
}

export type OutcomeDistribution = {
  category: string
  count: number
}

export type ImpactSummary = {
  generatedAt: string
  metrics: ImpactMetric[]
  monthlyTrend: MonthlyTrendPoint[]
  outcomes: OutcomeDistribution[]
}

export type DonationTrendPoint = {
  month: string
  amount: number
}

export type OutcomeTrendPoint = {
  month: string
  residentsServed: number
  homeVisits: number
}

export type SafehouseComparisonItem = {
  safehouse: string
  activeResidents: number
  allocatedFunding: number
}

export type ReintegrationRatePoint = {
  month: string
  ratePercent: number
}

export type SocialDonationCorrelationPoint = {
  group: string
  posts: number
  totalReach: number
  totalEngagements: number
  totalAttributedDonationAmount: number
  totalAttributedDonationCount: number
  donationsPer1kReach: number
  engagementRatePercent: number
}

export type SocialPostDonationInsight = {
  postMetricId: string
  postedAt: string
  platform: string
  contentType: string
  reach: number
  engagements: number
  attributedDonationAmount: number | null
  attributedDonationCount: number | null
  engagementRatePercent: number
}

export type ContentTimingRecommendationCard = {
  title: string
  rationale: string
  action: string
}

export type ReportsAnalyticsResponse = {
  donationTrends: DonationTrendPoint[]
  outcomeTrends: OutcomeTrendPoint[]
  safehouseComparisons: SafehouseComparisonItem[]
  reintegrationRates: ReintegrationRatePoint[]
  donationCorrelationByPlatform: SocialDonationCorrelationPoint[]
  donationCorrelationByContentType: SocialDonationCorrelationPoint[]
  donationCorrelationByPostingHour: SocialDonationCorrelationPoint[]
  topAttributedPosts: SocialPostDonationInsight[]
  recommendations: ContentTimingRecommendationCard[]
}

export type CreateSocialPostMetricRequest = {
  campaignId?: string | null
  postedAt: string
  platform: string
  contentType: string
  reach: number
  engagements: number
  attributedDonationAmount?: number | null
  attributedDonationCount?: number | null
}

export type SocialPostMetricListItem = {
  id: string
  campaignId: string | null
  postedAt: string
  platform: string
  contentType: string
  reach: number
  engagements: number
  attributedDonationAmount: number | null
  attributedDonationCount: number | null
}

// ── Donor Dashboard Types ─────────────────────────────────────────────────────
// These types mirror the C# DTOs in backend/SafeHarbor/SafeHarbor/DTOs/DonorDashboardDtos.cs.
// If you update the backend response shape, update these types to match.

/** A single month's donation total. Used to build the 12-month bar chart. */
export type MonthlyDonationPoint = {
  /** ISO year-month string, e.g. "2025-11". Used as the chart axis label. */
  month: string
  /** Total donated in this month, in USD. 0 for months with no donation. */
  amount: number
}

/** Campaign fundraising goal summary for the progress bar widget. */
export type CampaignGoalSummary = {
  campaignId: string
  campaignName: string
  /** Fundraising target for the entire campaign, in USD. */
  goalAmount: number
  /** Sum of all donors' completed contributions to this campaign. */
  totalRaisedAllDonors: number
  /** This specific donor's contribution to the campaign. */
  thisDonorContributed: number
  /** totalRaisedAllDonors / goalAmount * 100, capped at 100. Used as CSS --bar-width. */
  progressPercent: number
}

/**
 * The donor's estimated real-world impact.
 * modelVersion indicates whether the calculation came from a formula or ML pipeline.
 * This allows the UI to badge the source so donors and staff can see which model was used.
 */
export type DonorImpactSummary = {
  girlsHelped: number
  /** Human-readable label shown below the number, e.g. "girls supported toward safe housing". */
  impactLabel: string
  /** Identifies the calculation method, e.g. "rule-based-v1" or "ml-v2". */
  modelVersion: string
}

/** Full response from GET /api/donor/dashboard?email={email}. */
export type DonorDashboardData = {
  donorName: string
  /** Lifetime sum of all completed contributions by this donor, in USD. */
  lifetimeDonated: number
  /** 12 entries, one per calendar month, ascending. Zero-filled for months with no donation. */
  monthlyHistory: MonthlyDonationPoint[]
  /** Active campaign, or null if no campaign is currently running. */
  activeCampaign: CampaignGoalSummary | null
  impact: DonorImpactSummary
}

// ── Admin Donor Analytics Types ───────────────────────────────────────────────
// These types mirror the C# DTOs in backend/.../DTOs/DonorAnalyticsDtos.cs.
// Update both sides if the response shape changes.

/** A single month's aggregated data for the admin line chart. */
export type AnalyticsMonthlyPoint = {
  /** ISO year-month string, e.g. "2025-11". */
  month: string
  /** Total donations received in this month, in USD. 0 for months with no activity. */
  amount: number
  /** Number of donors who made their very first contribution in this month. */
  newDonors: number
}

/** Per-campaign OKR metrics for the Campaign OKRs section. */
export type CampaignAnalyticsSummary = {
  campaignId: string
  campaignName: string
  goalAmount: number
  totalRaised: number
  /** 0–100, used directly as CSS --stack-width percentage. */
  progressPercent: number
  donorCount: number
  contributionCount: number
}

/** A single top-donor entry for the leaderboard. */
export type TopDonorSummary = {
  displayName: string
  lifetimeDonated: number
  contributionCount: number
}

/** Full response from GET /api/admin/donor-analytics. */
export type DonorAnalyticsData = {
  totalDonationsReceived: number
  totalDonorCount: number
  activeDonorCount: number
  /** Percentage of donors who have given more than once. */
  retentionRate: number
  averageGiftSize: number
  totalContributionCount: number
  /** 12 entries, ascending, zero-filled. Drives the SVG line chart. */
  monthlyTrend: AnalyticsMonthlyPoint[]
  campaigns: CampaignAnalyticsSummary[]
  /** Top 5 donors by lifetime total. */
  topDonors: TopDonorSummary[]
}
