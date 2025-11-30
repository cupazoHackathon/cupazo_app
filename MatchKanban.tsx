
'use client'

import { useEffect, useState } from 'react'
import { matchesService, MatchGroupWithDetails } from '../services/matches.service'
import { useAuth } from '@/features/auth/hooks/useAuth'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { Badge } from '@/components/ui/badge'
import { Loader } from '@/components/ui/loader'
import { CheckCircle2, Clock, Package, Truck } from 'lucide-react'

const COLUMNS = [
    { id: 'lobby', title: 'En Lobby (Waiting)', icon: Clock, color: 'text-blue-500' },
    { id: 'pending_payment', title: 'Haciendo Match', icon: CheckCircle2, color: 'text-yellow-500' },
    { id: 'ready', title: 'Pagado / A Despachar', icon: Package, color: 'text-green-500' },
    { id: 'completed', title: 'En Camino / Completado', icon: Truck, color: 'text-gray-500' },
]

export function MatchKanban() {
    const { user } = useAuth()
    const [matches, setMatches] = useState<MatchGroupWithDetails[]>([])
    const [loading, setLoading] = useState(true)

    useEffect(() => {
        if (!user) return

        const loadMatches = async () => {
            // In a real scenario, we fetch from DB. 
            // For hackathon demo, if no data, we might want to seed some mock data or just show empty state.
            // Let's try to fetch first.
            const { data } = await matchesService.getSellerMatches(user.id)
            if (data) {
                setMatches(data)
            }
            setLoading(false)
        }

        loadMatches()
    }, [user])

    // Helper to categorize matches
    const getColumnMatches = (columnId: string) => {
        return matches.filter(match => {
            const isFull = match.members.length >= (match.max_group_size || 2)
            // Logic needs to be adapted based on real DB status values
            // Assuming: status 'pending' = lobby, 'filled' = pending_payment, 'paid' = ready, 'completed' = completed

            // For demo purposes, let's map loosely if status is missing
            const status = match.status || 'pending'

            if (columnId === 'lobby') return status === 'pending' && !isFull
            if (columnId === 'pending_payment') return status === 'filled' || (status === 'pending' && isFull)
            if (columnId === 'ready') return status === 'paid'
            if (columnId === 'completed') return status === 'completed'
            return false
        })
    }

    if (loading) return <Loader text="Cargando tablero de matches..." />

    return (
        <div className="flex h-[calc(100vh-200px)] gap-4 overflow-x-auto pb-4">
            {COLUMNS.map(column => (
                <div key={column.id} className="flex-shrink-0 w-80 flex flex-col bg-muted/30 rounded-lg border">
                    <div className="p-4 border-b bg-background/50 backdrop-blur-sm rounded-t-lg sticky top-0 z-10 flex items-center gap-2">
                        <column.icon className={`h-5 w-5 ${column.color}`} />
                        <h3 className="font-semibold text-sm">{column.title}</h3>
                        <Badge variant="secondary" className="ml-auto">
                            {getColumnMatches(column.id).length}
                        </Badge>
                    </div>
                    <div className="p-3 space-y-3 flex-1 overflow-y-auto">
                        {getColumnMatches(column.id).map(match => (
                            <MatchCard key={match.id} match={match} />
                        ))}
                        {getColumnMatches(column.id).length === 0 && (
                            <div className="h-24 flex items-center justify-center text-muted-foreground text-xs border-2 border-dashed rounded-md">
                                Sin actividad
                            </div>
                        )}
                    </div>
                </div>
            ))}
        </div>
    )
}

function MatchCard({ match }: { match: MatchGroupWithDetails }) {
    return (
        <Card className="shadow-sm hover:shadow-md transition-shadow cursor-pointer">
            <CardHeader className="p-3 pb-2">
                <div className="flex justify-between items-start">
                    <Badge variant="outline" className="text-[10px] truncate max-w-[150px]">
                        {match.deal?.title}
                    </Badge>
                    <span className="text-[10px] text-muted-foreground">
                        {new Date(match.created_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                    </span>
                </div>
            </CardHeader>
            <CardContent className="p-3 pt-2">
                <div className="flex items-center justify-center py-2 relative">
                    {/* Visual Connection Line */}
                    <div className="absolute top-1/2 left-1/4 right-1/4 h-0.5 bg-border -z-0" />

                    <div className="flex justify-between w-full px-4 z-10">
                        {/* Member Avatars */}
                        {Array.from({ length: match.max_group_size || 2 }).map((_, i) => {
                            const member = match.members[i]
                            return (
                                <div key={i} className="flex flex-col items-center gap-1">
                                    <Avatar className={`h-10 w-10 border-2 ${member ? (member.status === 'paid' ? 'border-green-500' : 'border-gray-300') : 'border-dashed border-muted-foreground/30'}`}>
                                        <AvatarImage src={member?.user?.raw_user_meta_data?.avatar_url} />
                                        <AvatarFallback className="text-[10px]">{member?.user?.name?.substring(0, 2) || '?'}</AvatarFallback>
                                    </Avatar>
                                    <span className="text-[10px] font-medium truncate w-16 text-center">
                                        {member ? member.user?.name || 'Usuario' : 'Esperando...'}
                                    </span>
                                </div>
                            )
                        })}
                    </div>
                </div>
                <div className="mt-2 text-xs text-center text-muted-foreground">
                    {match.members.length} / {match.max_group_size} unidos
                </div>
            </CardContent>
        </Card>
    )
}
